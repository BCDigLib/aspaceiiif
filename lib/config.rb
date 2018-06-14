require 'yaml'

module Aspaceiiif
  class Config
    def self.load
      conf = YAML::load_file('../config.yml')
    end
  end
end