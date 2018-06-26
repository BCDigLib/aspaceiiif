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

    def export_manifest
      metadata = Metadata.new(@dig_obj_id)

      manifest = generate_manifest(metadata)
    end

    def generate_manifest(metadata)
      seed = {
          '@id' => "#{@manifest_server}/#{metadata.component_id}.json",
          'label' => "#{metadata.title}",
          'viewing_hint' => 'paged',
          'attribution' => "#{metadata.rights_statement}",
          'metadata' => [
            {"handle": "#{metadata.handle}"},
            {"label": "Preferred Citation", "value": "#{metadata.creator + ", " unless metadata.creator.nil?}#{metadata.title}, #{metadata.resource_id}, #{metadata.owner}, #{metadata.handle}."}
          ]
      }
      IIIF::Presentation::Manifest.new(seed)
    end

    def generate_annotation
    end

    def generate_image_resource
    end

    def build_canvas
    end

    def build_range
    end
  end
end
