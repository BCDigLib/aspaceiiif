require 'aspaceiiif/version'
require 'aspaceiiif/builder'
require 'optparse'

module ASpaceIIIF
  def self.run
    OptionParser.new do |parser|
      parser.banner = "Usage: aspaceiiif dig_obj_id"

      parser.on("-h", "--help", "Show this help message") do ||
        puts parser
        exit
      end
    end.parse!

    input = ARGV[0]

    if input.include?('.txt')
      inp_arr = File.readlines(input)
      inp_arr.map { |id| id.strip! }.reject! { |id| id.empty? }

      inp_arr.each do |id|
        builder = ASpaceIIIF::Builder.new(id)
        manifest = builder.generate_manifest
        manifest_json = manifest.to_json(pretty: true)
        manifest_fname = manifest["id"].split('/').last

        f = File.new(manifest_fname, 'w')
        f.write(manifest_json)
        f.close

        puts "Created manifest #{manifest_fname} for digital object #{id}"
      end
    else
      builder = ASpaceIIIF::Builder.new(input)
      manifest = builder.generate_manifest
      manifest_json = manifest.to_json(pretty: true)
      manifest_fname = manifest["@id"].split('/').last

      f = File.new(manifest_fname, 'w')
      f.write(manifest_json)
      f.close

      puts "Created manifest #{manifest_fname} for digital object #{input}"
    end
  end
end