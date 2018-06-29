require 'aspaceiiif/records'

module ASpaceIIIF
  class Metadata
    def initialize(dig_obj_id)
      as_records = Records.new(dig_obj_id)
      @digital_objects = as_records.digital_objects
      @digital_object_trees = as_records.digital_object_trees
      @digital_object_components = as_records.digital_object_components
      @archival_objects = as_records.archival_objects
      @resource = as_records.resource
      @linked_agents = as_records.linked_agents
    end

    def handle 
      @digital_objects.map { |record| record["digital_object_id"] }
    end

    def rights_statement
      @digital_objects.map { |record| record["notes"].select { |note| note["type"] == "userestrict" }[0]["content"][0] }
    end

    def title
      if host_title.nil?
        @digital_objects.map { |record| record["title"] }
      else
        @digital_objects.map { |record| record["title"] + ", " + host_title }
      end
    end

    def host_title
      @resource["title"]
    end

    def resource_id
      @resource["id_0"] + '.' + @resource["id_1"] + '.' + @resource["id_2"]
    end

    def component_id
      @archival_objects.map { |record| record["component_id"] }
    end

    def creator
      @linked_agents.map { |record| record["title"] }
    end

    def owner
      "John J. Burns Library, Boston College"
    end

    def filenames
      @digital_object_components.map do |comp|
        if comp["file_versions"][0]["use_statement"].include?("archive")
          comp["file_versions"][0]["file_uri"].chomp('.jpg').chomp('.tif').chomp('.jp2') + '.jp2'
        else
          comp["file_versions"][1]["file_uri"].chomp('.jpg').chomp('.tif').chomp('.jp2') + '.jp2'
        end
      end
    end
  end
end