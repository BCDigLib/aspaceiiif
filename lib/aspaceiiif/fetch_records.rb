require 'aspaceiiif/version'
require 'aspaceiiif/builder'
require 'aspaceiiif/view_builder'
require_relative 'logging'

module ASpaceIIIF
  class FetchRecords
    include Logging

    def initialize(argv)
      @input_type = argv[0]
      @input_id = argv[1]
    end
    
    def run
      logger.debug("Gem run at #{Time.new.inspect}")

      # TODO: break this out into separate methods for readability/DRYness
      starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      if @input_type == 'resource'
        # If given a resource ID, attempt to generate views and manifests for all
        # associated digital objects
        inp_arr = APIUtils.new.find_digital_objects(@input_id)

        if inp_arr.empty?
            logger.error("Could not find this record")
            return
        end

        logger.debug("Found #{inp_arr.length} digital object ID(s): #{inp_arr.join(", ")}")

        logger.debug("#{'-' * 45}")
        logger.debug("Now loading digital object records")

        inp_arr.each_with_index do |id, index|
            loop_starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
            logger.debug("[#{index + 1} of #{inp_arr.length}]")
            builder = ASpaceIIIF::Builder.new(id)
            manifest = builder.generate_manifest
            manifest_json = manifest.to_json(pretty: true)
            manifest_fname = manifest["@id"].split('/').last

            f = File.new("manifests/#{manifest_fname}", 'w')
            f.write(manifest_json)
            f.close
            logger.debug("Created IIIF manifest #{manifest_fname} for digital object #{id}")

            view_builder = ASpaceIIIF::ViewBuilder.new
            view_html = view_builder.build("manifests/#{manifest_fname}")
            view_fname = manifest_fname.chomp('.json')

            f = File.new("view/#{view_fname}", 'w')
            f.write(view_html)
            f.close
            logger.debug("Created Mirador view for manifest #{manifest_fname}")

            loop_ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
            loop_elapsed = loop_ending - loop_starting

            logger.debug("Loop time elaspsed: #{loop_elapsed}")
            logger.debug("#{'*' * 35}")
        end
      elsif @input_type == 'digital_object'
        # Attempt to generate view and manifest for single digital object
        builder = ASpaceIIIF::Builder.new(@input_id)
        manifest = builder.generate_manifest
        manifest_json = manifest.to_json(pretty: true)
        manifest_fname = manifest["@id"].split('/').last

        f = File.new("manifests/#{manifest_fname}", 'w')
        f.write(manifest_json)
        f.close

        logger.debug("Created IIIF manifest #{manifest_fname} for digital object #{@input_id}")

        view_builder = ASpaceIIIF::ViewBuilder.new
        view_html = view_builder.build("manifests/#{manifest_fname}")
        view_fname = manifest_fname.chomp('.json')

        f = File.new("view/#{view_fname}", 'w')
        f.write(view_html)
        f.close
        logger.debug("Created Mirador view for manifest #{manifest_fname}")
      end

      ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      elapsed = ending - starting
      logger.debug("Total time elaspsed: #{elapsed}")
    end
  end
end