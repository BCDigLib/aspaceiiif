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

    def use_statement
      if @digital_object["notes"].select { |note| note["type"] == "userestrict" }.length > 0
        @digital_object["notes"].select { |note| note["type"] == "userestrict" }[0]["content"][0]
      else
        # Placeholder until we have a general purpose use use statement
        "Please contact the Burns Library for information on reuse."
      end
    end

    def title
      if host_title.nil? || host_title == @digital_object["title"]
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
      if @archival_object["component_id"]
        @archival_object["component_id"]
      elsif handle.include?('BC') || handle.include?('MS')
        handle.split('/').last
      end
    end

    def creator
      # We include creator in manifests for Japanese prints only
      @linked_agent["title"] if host_title == "Japanese prints collection"
    end

    def owner
      "John J. Burns Library, Boston College"
    end

    def filenames
      # First delete the color target component
      @digital_object_components.delete_if { |comp| comp["title"].include?('_target') }

      @digital_object_components.delete_if { |comp| comp["title"].include?('_INT') }

      @digital_object_components.map do |comp|
        if comp["file_versions"][0]["use_statement"].include?("master") || comp["file_versions"][0]["use_statement"].include?("archive")
          if comp["file_versions"][0]["file_uri"].include?('://')
            fname = comp["file_versions"][0]["file_uri"].split('/').last
            fname.chomp('.jpg').chomp('.tif').chomp('.jp2') + '.jp2'
          elsif comp["file_versions"][0]["file_uri"].include?('_MAS')
            comp["file_versions"][0]["file_uri"].chomp('.jpg').chomp('.tif').chomp('.jp2').chomp('_MAS') + '.jp2'
          else
            comp["file_versions"][0]["file_uri"].chomp('.jpg').chomp('.tif').chomp('.jp2') + '.jp2'
          end
        elsif comp["file_versions"].length > 1
          if comp["file_versions"][1]["file_uri"].include?('://')
            fname = comp["file_versions"][0]["file_uri"].split('/').last
            fname.chomp('.jpg').chomp('.tif').chomp('.jp2') + '.jp2'
          else
            comp["file_versions"][1]["file_uri"].chomp('.jpg').chomp('.tif').chomp('.jp2') + '.jp2'
          end
        end
      end
    end
  end
end