require File.dirname(__FILE__) + '/FlashPhoto.rb'
require 'rest_client'

FLASH_USERNAME = "alex"
FLASH_PASSWORD = "i6tNMuI1zSloXbQyIjaDcMtscKU0eOzH"

def do_the_foo(image_id, other_image_id)
  puts "Starting merge"
  flash = FlashPhoto.new(FLASH_USERNAME, FLASH_PASSWORD)

  puts "finding face one"
  faces_one = flash.find_faces(image_id)  
  if faces_one.size < 1
    puts "no faces found"
    return
  end
  
  puts "finding face two"
  faces_two = flash.find_faces(other_image_id)
  if faces_two.size < 1
    puts "no faces found"
    return
  end
  
  puts "initializing segmentation"
  flash.segment(other_image_id)
  
  puts "waiting for segmentation to finish"
  i = 0
  while(true) 
    if i > 20 
      puts "waited too long, abandoning"
      return
    end
    i += 1
    sleep(1)
    
    puts "Checking Segment Status"
    break if flash.segment_status(other_image_id)
  end
  
  other_face = faces_two[0]
  
  previous_image_id = image_id
  
  puts "iterating over faces in first image"
  faces_one.each do |face|
    
    puts "calculating data"
    angle = face["Face"]["head_rotation"]    
    ratio = (face["Face"]["head_width"].to_f / other_face["Face"]["head_width"].to_f) * 100
    x = face["Face"]["head_position_x"]
    y = face["Face"]["head_position_y"] + (face["Face"]["head_width"] / 2)
    
    json = JSON.generate([
        {
          "image_id" => previous_image_id
        }, { 
          "image_id" => other_image_id, 
          "version" => "SoftMasked", 
          "x" => x, 
          "y" => y, 
          "scale" => ratio, 
          "angle" => angle, 
          "flip" => 0
        } 
    ])
    
    puts "merging"
    url = "http://flashfotoapi.com/api/merge?partner_username=#{FLASH_USERNAME}&partner_apikey=#{FLASH_PASSWORD}&privacy=public"
    response_json = RestClient.post url, json, {:content_type => :json, :accept => :json}
    response = JSON.parse(response_json)
    previous_image_id = response["ImageVersion"]["image_id"]    
    puts "merge stage complete"
  end
  
  puts "all merges complete: result: #{previous_image_id}"
  puts previous_image_id
end

RestClient.log = "/dev/stdout"

image_id = ARGV[0]
other_image_id = ARGV[1]

do_the_foo(image_id, other_image_id)