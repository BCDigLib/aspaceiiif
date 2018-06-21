require 'aspaceiiif/records'

module ASpaceIIIF
  class Metadata
    def initialize(dig_obj_id)
      as_records = Records.new(dig_obj_id)
      @digital_object = as_records.digital_object
      @digital_object_tree = as_records.digital_object_tree
      @archival_object = as_records.archival_object
      @resource = as_records.resource
    end

    def handle 
      @digital_object["digital_object_id"]
    end

    def rights_statement
      @digital_object["notes"].select { |note| note["type"] == "userestrict" }[0]["content"][0]
    end

    def title
      @digital_object["title"]
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
    end

    def filenames
    end
  end
end