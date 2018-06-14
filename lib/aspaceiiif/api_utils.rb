require 'aspaceiiif/config'
require 'json'

module Aspaceiiif
  class APIUtils
    def initialize
      @conf = Config.load
      auth_resp = RestClient::Request.execute(method: :post, 
                                             url: @conf["aspace_base_uri"] + '/users/admin/login',
                                             payload: { password: @conf["aspace_password"] }
      )
      auth_resp_serialized = JSON.parse(auth_resp)
      @session_id = auth_resp_serialized["session"]
    end

    def get_record(uri_suffix)
      endpoint = @conf["aspace_base_uri"] + uri_suffix
      response = RestClient.get(endpoint, {"X-ArchivesSpace-Session": @session_id})
      JSON.parse(response)
    end
  end
end