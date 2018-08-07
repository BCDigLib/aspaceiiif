require 'aspaceiiif/records'

module ASpaceIIIF
  class Metadata
    def initialize(dig_obj_id)
      as_records = Records.new(dig_obj_id)
      @digital_object = as_records.digital_object
      @digital_object_tree = as_records.digital_object_tree
      @digital_object_components = as_records.digital_object_components
      @archival_object = as_records.archival_object
      @resource = as_records.resource
      @linked_agent = as_records.linked_agent
    end

    def handle 
      @digital_object["digital_object_id"]
    end

    def rights_statement
      @digital_object["notes"].select { |note| note["type"] == "userestrict" }[0]["content"][0]
    end

    def title
      if host_title.nil?
        @digital_object["title"]
      else
        @digital_object["title"] + ", " + host_title
      end
    end

    def host_title
      @resource["title"]
    end

    def resource_id
      @resource["id_0"] + '.' + @resource["id_1"] + '.' + @resource["id_2"]
    end

    def component_id
      @archival_object["component_id"]
    end

    def creator
      @linked_agent["title"]
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