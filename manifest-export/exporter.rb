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

  def get_digital_object(input)
    digital_object_base_uri = @conf["aspace_base_uri"] + '/repositories/2/digital_objects/'
    endpoint = digital_object_base_uri + input
    response = RestClient.get(endpoint, {"X-ArchivesSpace-Session": @session_id})
    digital_object = JSON.parse(response)
  end

  def get_archival_object(input)
    archival_object_base_uri = @conf["aspace_base_uri"] + '/repositories/2/archival_objects/'
    endpoint = archival_object_base_uri + input
    response = RestClient.get(endpoint, {"X-ArchivesSpace-Session": @session_id})
    archival_object = JSON.parse(response)
  end


end