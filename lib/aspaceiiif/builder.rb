require 'aspaceiiif/config'
require 'iiif/presentation'

module ASpaceIIIF
  class Builder
    def initialize(dig_obj_id)
      conf = Config.load
      @image_server = conf["image_server_base_uri"]
      @manifest_server = conf["manifest_server_base_uri"]
      @dig_obj_id = dig_obj_id
    end

    def build_manifest
    end

    def generate_annotation
    end

    def generate_image_resource
    end
  end
end
