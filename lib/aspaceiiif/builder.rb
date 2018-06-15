require 'aspaceiiif/config'
require 'iiif/presentation'

module ASpaceIIIF
  class Builder
    def initialize
      conf = Config.load
      @image_server = conf["image_server_base_uri"]
      @manifest_server = conf["manifest_server_base_uri"]
    end

    def export_manifest
    end

    def build_manifest(dig_obj_id)
      as_records = Records.new(dig_obj_id)
      digital_object = as_records.digital_object
      digital_object_tree = as_records.digital_object_tree
      archival_object = as_records.archival_object
      resource = as_records.resource
    end

    def handle 
      digital_object["digital_object_id"]
    end

    def rights_statement
      digital_object["notes"].select { |note| note["type"] == "userestrict" }[0]["content"][0]
    end

    def generate_annotation
    end

    def generate_image_resource
    end
  end
end
