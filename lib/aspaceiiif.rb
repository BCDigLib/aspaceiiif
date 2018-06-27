require 'aspaceiiif/version'
require 'aspaceiiif/builder'

module ASpaceIIIF
  def self.run    
    dig_obj_id = ARGV[0]

    builder = ASpaceIIIF::Builder.new(dig_obj_id)
    manifest = builder.generate_manifest

    puts manifest.to_json(pretty: true)
  end
end