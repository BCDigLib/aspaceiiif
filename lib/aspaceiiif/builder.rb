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

    def build_manifest
    end

    def generate_annotation
    end

    def generate_image_resource
    end
  end
end
