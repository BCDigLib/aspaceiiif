require 'yaml'

module Aspaceiiif
  class Config
    def self.root
      File.dirname 'aspace-to-iiif'
    end

    def self.load
      conf = YAML::load_file(File.join(root, 'config.yml'))
    end
  end
end
