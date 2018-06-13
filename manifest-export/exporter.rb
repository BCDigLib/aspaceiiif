require 'iiif/presentation'
require 'rest-client'
require 'json'
require 'yaml'

class ManifestExporter
  def initialize(cnf_file)
    @conf = YAML::load_file(cnf_file)
  end

  def authenticate
    auth_resp = RestClient::Request.execute(method: :post, 
                                           url: @conf["aspace_base_uri"] + '/users/admin/login',
                                           payload: {password: @conf["aspace_password"]}
    )
    auth_resp_serialized = JSON.parse(auth_resp)
    @session_id = auth_resp_serialized["session"]
  end
end