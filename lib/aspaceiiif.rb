require 'aspaceiiif/version'
require 'aspaceiiif/builder'
require 'aspaceiiif/view_builder'
require 'optparse'

module ASpaceIIIF
  def self.run
    OptionParser.new do |parser|
      parser.banner = "Usage: aspaceiiif [ digital_object_id | digital_object_ids.txt ]"

      parser.on("-h", "--help", "Show this help message") do ||
        puts parser
        exit
      end
    end.parse!

    Dir.mkdir('manifests') unless File.exists?('manifests')
    Dir.mkdir('view') unless File.exists?('view')

    input = ARGV[0]

    if input.include?('.txt')
      # If given a text file, attempt to generate views and manifests for 
      # multiple digital object IDS in the file
      inp_arr = File.readlines(input)
      inp_arr.map { |id| id.strip! }.reject! { |id| id.empty? }

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

        f = File.new("view/#{view_fname}", 'w')
        f.write(view_html)
        f.close
        puts "Created Mirador view for manifest #{manifest_fname}"
      end
    else
      # Given no text file, attempt to generate view and manifest for single 
      # digital object
      builder = ASpaceIIIF::Builder.new(input)
      manifest = builder.generate_manifest
      manifest_json = manifest.to_json(pretty: true)
      manifest_fname = manifest["@id"].split('/').last

      f = File.new("manifests/#{manifest_fname}", 'w')
      f.write(manifest_json)
      f.close

      puts "Created IIIF manifest #{manifest_fname} for digital object #{input}"

      view_builder = ASpaceIIIF::ViewBuilder.new
      view_html = view_builder.build("manifests/#{manifest_fname}")
      view_fname = manifest_fname.chomp('.json')

      f = File.new("view/#{view_fname}", 'w')
      f.write(view_html)
      f.close
      puts "Created Mirador view for manifest #{manifest_fname}"
    end
  end
end
