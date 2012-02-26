require 'json'
require 'rest_client'

CREATE_SESSION_URL = "https://connect.gettyimages.com/v1/session/CreateSession"
SEARCH_FOR_IMAGES_URL = "http://connect.gettyimages.com/v1/search/SearchForImages"
GET_IMAGE_DOWNLOAD_AUTH_TOKEN_URL = "http://connect.gettyimages.com/v1/download/GetLargestImageDownloadAuthorizations"
CREATE_DOWNLOAD_REQUEST_URL = "https://connect.gettyimages.com/v1/download/CreateDownloadRequest"
CREATE_SESSION_PATH = "/v1/session/CreateSession"
class Getty  
  attr_accessor :session_token
  attr_accessor :secure_session_token
  attr_accessor :token_expiry
  attr_accessor :valid_token
  
  def update_session!
    create_session if (token_expiry < Time.now) 
  end
  
  def create_session
    
    system_id = "3103"
    system_password = "ORPmyjBv5qQad7V3+YKaefTsXUs+d9KDioYigzsOYfA="
    user_name = "photohackday_3103"
    user_password = "S1fK81FX9njJ"
    
    json_request = JSON.generate({
        "RequestHeader" => {
          "Token" => "",
          "CoordinationId" => ""
        },
        "CreateSessionRequestBody" => {
          "SystemId"        => system_id,
          "SystemPassword"  => system_password,
          "UserName"        => user_name,
          "UserPassword"    => user_password
        }
    })
    
    begin
      response_json = RestClient.post(CREATE_SESSION_URL, json_request, {:content_type => :json, :accept => :json})
      response = JSON.parse(response_json)
      if response["ResponseHeader"]["Status"] == "success"
        self.session_token = response["CreateSessionResult"]["Token"]
        self.secure_session_token = response["CreateSessionResult"]["SecureToken"]
        self.token_expiry = Time.now + response["CreateSessionResult"]["TokenDurationMinutes"].to_i * 60
        self.valid_token = true
        
      end
    rescue
      
    end
  end
  
  def search_images(search_phrase)
    update_session!      
    json_request = JSON.generate(
      {"RequestHeader" => {
        "Token" => session_token,
        "CoordinationId" => ""
      },
      "SearchForImages2RequestBody" => {
        "Query"         => {
          "SearchPhrase" => search_phrase
        },
        "Filter"        => {
          "ImageFamily"  => ["creative"]
        },
        "ResultOptions" => {
          "IncludeKeywords" => false,
          "ItemCount"       => 25,
          "ItemStartNumber" => 1
        }
      }
    })
    
    begin
      response_json = RestClient.post(SEARCH_FOR_IMAGES_URL, json_request, {:content_type => :json, :accept => :json})
      response = JSON.parse(response_json)
      return response["SearchForImagesResult"]
    rescue
      
    end   
  end
  
  def get_image_authorization_token(image_id) 
    update_session!    
    json_request = JSON.generate({
      "RequestHeader" => {
        "CoordinationId" => "",
        "Token"          => session_token
      },
      "GetLargestImageDownloadAuthorizationsRequestBody" =>
        { "Images" => [
          {"ImageId" => image_id}
        ]}
    }) 

    begin
      response_json = RestClient.post(GET_IMAGE_DOWNLOAD_AUTH_TOKEN_URL, json_request, {:content_type => :json, :accept => :json})      
      response = JSON.parse(response_json)
      return response["GetLargestImageDownloadAuthorizationsResult"]["Images"][0]["Authorizations"][0]["DownloadToken"]
    rescue
      
    end
  end
  
  
  def get_image_download_url(token)
    update_session!
    json_request = JSON.generate({
      "RequestHeader" => {
        "CoordinationId" => "",
        "Token"          => secure_session_token
      },
      "CreateDownloadRequestBody" => {
        "DownloadItems" => [{ "DownloadToken" => token }]
      }
    })
    
    begin
      response_json = RestClient.post(CREATE_DOWNLOAD_REQUEST_URL, json_request, {:content_type => :json, :accept => :json})      
      response = JSON.parse(response_json)
      return response["CreateDownloadRequestResult"]["DownloadUrls"][0]["UrlAttachment"]
    rescue
      
    end
  end
end
