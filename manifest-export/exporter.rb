require 'iiif/presentation'
require 'rest-client'
require 'json'
require 'yaml'

module ManifestExport
  class APIUtils
    def initialize(cnf_file)
      @conf = YAML::load_file(cnf_file)
      auth_resp = RestClient::Request.execute(method: :post, 
                                             url: @conf["aspace_base_uri"] + '/users/admin/login',
                                             payload: {password: @conf["aspace_password"]}
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

  class Records
    def initialize(dig_obj_id)
      @dig_obj_id = dig_obj_id
      @conn = APIUtils.new('config.yml')
    end

    def digital_object
      @conn.get_digital_object(@dig_obj_id)
    end

    def digital_object_tree
      @conn.get_digital_object_tree(@dig_obj_id)
    end

    def archival_object
      arch_obj_id = digital_object["linked_instances"][0]["ref"].split("/").last
      @conn.get_parent_archival_object(arch_obj_id)
    end

    def resource
      resource_id = archival_object["resource"]["ref"].split("/").last
      @conn.get_parent_resource(resource_id)
    end
  end

  class Builder
    def initialize
    end

    def export_manifest
    end

    def build_manifest
    end

    def generate_annotation
    end

    def generate_image_resource
    end
  end
end