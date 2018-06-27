require 'aspaceiiif/version'
require 'aspaceiiif/builder'

module ASpaceIIIF
  def self.run
    OptionParser.new do |parser|
      parser.banner = "Usage: aspaceiiif dig_obj_id"

      parser.on("-h", "--help", "Show this help message") do ||
        puts parser
        exit
      end
    end.parse!

    dig_obj_id = ARGV[0]

    builder = ASpaceIIIF::Builder.new(dig_obj_id)
    manifest = builder.generate_manifest

    puts manifest.to_json(pretty: true)
  end
end