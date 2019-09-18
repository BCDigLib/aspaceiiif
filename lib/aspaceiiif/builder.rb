require 'aspaceiiif/config'
require 'aspaceiiif/metadata'
require 'iiif/presentation'

module ASpaceIIIF
  class Builder
    def initialize(dig_obj_id)
      conf = Config.load
      @image_server = conf["image_server_base_uri"]
      @manifest_server = conf["manifest_server_base_uri"]
      @dig_obj_id = dig_obj_id
    end

    def generate_manifest
      metadata = Metadata.new(@dig_obj_id)

      @sequence_base = "#{@image_server}/#{metadata.component_id}"

      sequence = IIIF::Presentation::Sequence.new
      range = IIIF::Presentation::Range.new

      sequence.canvases = metadata.component_labels_filenames.each_with_index { |comp, i| generate_canvas(comp[0], comp[1], i) }
      range.ranges = metadata.component_labels_filenames.each_with_index { |comp, i| generate_range(comp[0], comp[1], i) }

      seed = {
          '@id' => "#{@manifest_server}/#{metadata.component_id}.json",
          'label' => "#{metadata.title}",
          'viewing_hint' => 'paged',
          'attribution' => "#{metadata.use_statement}",
          'metadata' => [
            {"handle": "#{metadata.handle}"},
            {"label": "Preferred Citation", "value": "#{metadata.creator + ", " unless metadata.creator.nil?}#{metadata.title}, #{metadata.resource_id}, #{metadata.owner}, #{metadata.handle}."}
          ]
      }
      manifest = IIIF::Presentation::Manifest.new(seed)

      manifest.sequences << sequence
      manifest.structures << range
      thumb = sequence.canvases.first.images.first.resource['@id'].gsub(/full\/full/, 'full/!200,200')
      manifest.insert_after(existing_key: 'label', new_key: 'thumbnail', value: thumb)

      structures = manifest["structures"][0]["ranges"]
      manifest["structures"] = structures

      manifest
    end

    def parse_sequence_number(label)
      separator = label.include?('_') ? '_' : '.'
      page_id_arr = label.split(separator)
      
      # Use extended page_id for filenames that include a folder number
      page_id_arr[-2].match(/^\d{2}$|^\d{3}$/) ? page_id_arr[-2] + '_' + page_id_arr[-1] : page_id_arr.last
    end

    def generate_canvas(label, image_file, order)
      page_id = parse_sequence_number(label)

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
      image_api_params = 'full/full/0/default.jpg'

      params = {
          service_id: base_uri,
          resource_id_default: "#{base_uri}/#{image_api_params}",
          resource_id: "#{base_uri}/#{image_api_params}"
      }
      IIIF::Presentation::ImageResource.create_image_api_image_resource(params)
    end

    def generate_range(label, image_file, order)
      page_id = parse_sequence_number(label)

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
