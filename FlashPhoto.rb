require 'rest_client'
require 'json'
require 'Base64'

class FlashPhoto
  attr_accessor :email, :username, :password
  
  def initialize(username, password)
    self.username = username
    self.password = password
  end
  
  def upload(image_url)
    location = (Base64.encode64 image_url).gsub(/\n/, '')
    url = "http://flashfotoapi.com/api/add?privacy=public&partner_username=#{username}&partner_apikey=#{password}&location=#{location}"
    response_json = RestClient.post url, '', {:content_type => :json, :accept => :json}
    response = JSON.parse(response_json)
    response["ImageVersion"]["image_id"]    
  end
  
  def find_faces(image_id)
      url = "http://flashfotoapi.com/api/findfaces/#{image_id}?partner_username=#{username}&partner_apikey=#{password}"
      response_json = RestClient.get url, :content_type => :json
      JSON.parse(response_json)
  end
  
  def segment(image_id)
    url = "http://flashfotoapi.com/api/segment/#{image_id}?partner_username=#{username}&partner_apikey=#{password}"
    response_json = RestClient.get url, :content_type => :json
    JSON.parse(response_json)
  end
  
  def segment_status(image_id)
    begin
      url2 = "http://flashfotoapi.com/api/segment_status/#{image_id}?partner_username=#{username}&partner_apikey=#{password}"
      response_json = RestClient.get url2, :content_type => :json
      response = JSON.parse(response_json)    
    
      if response["segmentation_status"] == "pending"
        return false
      elsif response["segmentation_status"] == "finished"
        return true
      end
    rescue
      return false
    end
  end
  
  def hard_mask(image_id)
    url = "http://flashfotoapi.com/api/get/#{image_id}?version=HardMask&partner_username=#{username}&partner_apikey=#{password}"
    response_json = RestClient.get url2, :content_type => :json
    response = JSON.parse(response_json)
  end  
end