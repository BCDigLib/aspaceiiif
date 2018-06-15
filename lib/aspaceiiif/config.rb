require 'yaml'

module Aspaceiiif
  class Config
    def self.load
      YAML::load_file(File.join(__dir__, '../../config.yml'))
    end
  end
end
