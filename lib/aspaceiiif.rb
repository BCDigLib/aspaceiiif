require 'aspaceiiif/version'
require 'aspaceiiif/builder'
require 'aspaceiiif/view_builder'
require 'optparse'

module ASpaceIIIF
  def self.run
    OptionParser.new do |parser|
      parser.banner = "Usage: aspaceiiif [ resource | digital_object ] [ id (db primary key) ]
      e.g., aspaceiiif resource 15"

      parser.on("-h", "--help", "Show this help message") do ||
        puts parser
        exit
      end
    end.parse!

    Dir.mkdir('manifests') unless File.exists?('manifests')
    Dir.mkdir('views') unless File.exists?('views')

    input_type = ARGV[0]
    input_id = ARGV[1]

    if input_type == 'resource'
      # If given a resource ID, attempt to generate views and manifests for all 
      # associated digital objects
      inp_arr = APIUtils.new.find_digital_objects(input_id)

      inp_arr.each do |id|
        builder = ASpaceIIIF::Builder.new(id)
        manifest = builder.generate_manifest
        manifest_json = manifest.to_json(pretty: true)
        manifest_fname = manifest["@id"].split('/').last

        f = File.new("manifests/#{manifest_fname}", 'w')
        f.write(manifest_json)
        f.close
        puts "Created IIIF manifest #{manifest_fname} for digital object #{id}"

        view_builder = ASpaceIIIF::ViewBuilder.new
        view_html = view_builder.build("manifests/#{manifest_fname}")
        view_fname = manifest_fname.chomp('.json')

        f = File.new("views/#{view_fname}", 'w')
        f.write(view_html)
        f.close
        puts "Created Mirador view for manifest #{manifest_fname}"
      end
    elsif input_type == 'digital_object'
      # Attempt to generate view and manifest for single digital object
      builder = ASpaceIIIF::Builder.new(input_id)
      manifest = builder.generate_manifest
      manifest_json = manifest.to_json(pretty: true)
      manifest_fname = manifest["@id"].split('/').last

      f = File.new("manifests/#{manifest_fname}", 'w')
      f.write(manifest_json)
      f.close

      puts "Created IIIF manifest #{manifest_fname} for digital object #{input_id}"

      view_builder = ASpaceIIIF::ViewBuilder.new
      view_html = view_builder.build("manifests/#{manifest_fname}")
      view_fname = manifest_fname.chomp('.json')

      f = File.new("views/#{view_fname}", 'w')
      f.write(view_html)
      f.close
      puts "Created Mirador view for manifest #{manifest_fname}"
    end
  end
end
