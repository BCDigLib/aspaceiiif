require 'aspaceiiif/records'

module ASpaceIIIF
  class Metadata
    def initialize(dig_obj_id)
      as_records = Records.new(dig_obj_id)
      @digital_object = as_records.digital_object
      @digital_object_tree = as_records.digital_object_tree
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
      @linked_agent["title"]
    end

    def filenames
      tree_children = @digital_object_tree["children"]
      fnames = []
      tree_children.each { |e| fnames << e["file_versions"][0]["file_uri"].chomp('.jpg').chomp('.tif').chomp('.jp2') + '.jp2' }

      fnames.sort!
    end
  end
end