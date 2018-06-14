require 'iiif/presentation'
require 'rest-client'
require 'json'
require 'yaml'

module ManifestExport
  class Config
    def self.load
      conf = YAML::load_file('config.yml')
    end
  end

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

  class Records
    def initialize(dig_obj_id)
      @dig_obj_id = dig_obj_id
      @conn = APIUtils.new
    end

    def digital_object
      uri_suffix = '/repositories/2/digital_objects/' + @dig_obj_id
      @conn.get_record(uri_suffix)
    end

    def digital_object_tree
      tree_id = digital_object["tree"]["ref"]
      @conn.get_record(tree_id)
    end

    def archival_object
      arch_obj_id = digital_object["linked_instances"][0]["ref"]
      @conn.get_record(arch_obj_id)
    end

    def resource
      resource_id = archival_object["resource"]["ref"]
      @conn.get_record(resource_id)
    end
  end

  class Builder
    def initialize
      conf = Config.load
      @image_server = conf["loris_base_uri"]
      @manifest_server = conf["mirador_base_uri"]
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