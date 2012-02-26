require 'sinatra'
require File.dirname(__FILE__) + "/Getty.rb"
require 'open-uri'
#require 'image_downloader'
require 'aws/s3'
require File.dirname(__FILE__) + "/FlashPhoto.rb"


configure do
  set :bind, '0.0.0.0'
  GETTY = Getty.new
  GETTY.create_session
  IMAGE_COUNT = []
  
  S3_ACCESS_KEY = "AKIAICYO4WWLUKD3IDPA"
  S3_SECRET = "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"
  
  AWS::S3::Base.establish_connection!(
      :access_key_id     => S3_ACCESS_KEY,
      :secret_access_key => S3_SECRET
  )
  
  BUCKET_NAME = "onyourface.biz"  
  BUCKET = AWS::S3::Service.buckets.find(BUCKET_NAME).first
  
  FLASH_USERNAME = "alex"
  FLASH_PASSWORD = "i6tNMuI1zSloXbQyIjaDcMtscKU0eOzH"
end

get "/" do
  File.read(File.join('public', 'index.html'))
end

get "/search/:search_term" do
  results = GETTY.search_images(params[:search_term])
  response_data = results["Images"].map{|image| {:url => image["UrlPreview"], :thumb_url => image["UrlThumb"], :image_id => image["ImageId"]}}
  
  # html = "<html><body>"
  # response_data.each {|r| 
  #   html += "<a href='/foo/#{r[:image_id]}'>load</a><img src='#{r[:url]}'>#{r[:url]}<br /><hr /><br />"
  # }
  # html + "</body></html>"
  response_data.to_json
end

get "/foo/:image_id" do  
  url = ""
  #begin
    #puts "finding file on s3"
  #  obj = AWS::S3::S3Object.find "#{params[:image_id]}.jpg", BUCKET_NAME
  #  puts "file found on s3"
  #  url = obj.url
  #rescue
    #image not found!\
    
    puts "#{params[:photo_id]}"
    puts "image not found on s3, getting auth token"
    token = GETTY.get_image_authorization_token(params[:image_id])    
    if token == nil || token == ""
      return "auth token error"
    end
    puts "found token: #{token}"
    getty_url = GETTY.get_image_download_url(token)
    if getty_url == nil || getty_url == ""
      return "getty url not found"
    end
    
    file_name = "#{params[:image_id]}.jpg"
    
    download getty_url, "tmp/#{file_name}"
    #AWS::S3::S3Object.store(file_name, open("tmp/#{file_name}"), 'onyourface.biz')
    #obj = AWS::S3::S3Object.find file_name, BUCKET_NAME
    #url = obj.url
    
    url = getty_url
  #end
  
  puts "url of file on s3 #{url}"
  
  #upload to fotomagicthings
  flash = FlashPhoto.new(FLASH_USERNAME, FLASH_PASSWORD)
  photo_id = flash.upload(url)
  
  puts photo_id
  
  
  #{}"<html><body><a href='#{url}'>#{photo_id}</a></body></html>"
  #{:url => url}.to_json
  {:photo_id => photo_id}.to_json
end

get "/bar/:image_id/:other_image_id" do
  id = do_the_foo(params[:image_id], params[:other_image_id])
  {:url => "http://flashfotoapi.com/api/get/#{id}"}.to_json
end


def download full_url, to_here
  puts "#{full_url}"
  puts "#{to_here}"
  writeOut = open(to_here, "wb")
  writeOut.write(open(full_url).read)
  writeOut.close
end
<<<<<<< HEAD

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
