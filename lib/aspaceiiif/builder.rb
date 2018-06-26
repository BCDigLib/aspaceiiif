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

    def generate_canvas(image_file, label, order)
      separator = image_file.include?('_') ? '_' : '.'
      image_id = image_file.chomp('.jp2').chomp('.tif').chomp('.tiff').chomp('.jpg')
      page_id = image_id.split(separator).last

      canvas_id = "#{@sequence_base}/canvas/#{page_id}"

      annotation_seed = {
          '@id' => "#{canvas_id}/annotation/1",
          'on' => canvas_id
      }
      annotation = IIIF::Presentation::Annotation.new(annotation_seed)
      annotation.resource = generate_image_resource(image_file)

      canvas_seed = {
          '@id' => canvas_id,
          'label' => label,
          'width' => annotation.resource['width'],
          'height' => annotation.resource['height'],
          'images' => [annotation]
      }
      IIIF::Presentation::Canvas.new(canvas_seed)
    end

    def generate_image_resource(image_file)
      base_uri = "#{@image_server}/#{image_file}"
      image_api_params = '/full/full/0/default.jpg'

      params = {
          service_id: base_uri,
          resource_id_default: "#{base_uri}#{image_api_params}",
          resource_id: "#{base_uri}#{image_api_params}"
      }
      IIIF::Presentation::ImageResource.create_image_api_image_resource(params)
    end

    def generate_range(image_file, label, order)
      separator = image_file.include?('_') ? '_' : '.'
      image_id = image_file.chomp('.jp2').chomp('.tif').chomp('.tiff').chomp('.jpg')
      page_id = image_id.split(separator).last

      range_id = "#{@sequence_base}/range/r-#{order}"
      canvas_id = "#{@sequence_base}/canvas/#{page_id}"

      seed = {
          '@id' => range_id,
          'label' => label,
          'canvases' => [canvas_id]
      }
      IIIF::Presentation::Range.new(seed)
    end
  end
end
