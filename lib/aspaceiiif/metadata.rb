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
      @digital_object_pk = dig_obj_id
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
      else
        raise "Digital object #{@digital_object_pk} has no corresponding component unique ID."
      end
    end

    def creator
      # We include creator in manifests for Japanese prints only
      @linked_agent["title"] if host_title == "Japanese prints collection"
    end

    def owner
      # Hardcoding this because it is not included in ArchivesSpace records
      "John J. Burns Library, Boston College"
    end

    def component_labels_filenames
      components_fnames = {}

      # First delete the color target component
      @digital_object_components.delete_if { |comp| comp["title"].include?('_target') }

      # Next, remove intermediates so we don't end up with duplicate filenames
      @digital_object_components.delete_if { |comp| comp["title"].include?('_INT') }

      # Finally, map labels to filenames, accounting for various quirks
      # TODO: refactor for simplicity and clarity once we rebuild legacy DOs
      @digital_object_components.map do |comp|
        if comp["file_versions"][0]["use_statement"].include?("master") || comp["file_versions"][0]["use_statement"].include?("archive")
          if comp["file_versions"][0]["file_uri"].include?('://')
            fname = comp["file_versions"][0]["file_uri"].split('/').last.chomp('.jpg').chomp('.tif').chomp('.jp2') + '.jp2'
            comp["label"] ? label = comp["label"] : label = comp["title"]

            components_fnames[label] = fname
          elsif comp["file_versions"][0]["file_uri"].include?('_MAS')
            fname = comp["file_versions"][0]["file_uri"].chomp('.jpg').chomp('.tif').chomp('.jp2').chomp('_MAS') + '.jp2'
            comp["label"] ? label = comp["label"] : label = comp["title"]

            components_fnames[label] = fname
          else
            fname = comp["file_versions"][0]["file_uri"].chomp('.jpg').chomp('.tif').chomp('.jp2') + '.jp2'
            comp["label"] ? label = comp["label"] : label = comp["title"]

            components_fnames[label] = fname
          end
        elsif comp["file_versions"].length == 1 && comp["file_versions"][0]["use_statement"].include?("access_copy")
          if comp["file_versions"][0]["file_uri"].include?('://')
            fname = comp["file_versions"][0]["file_uri"].split('/').last.chomp('.jpg').chomp('.tif').chomp('.jp2') + '.jp2'
            comp["label"] ? label = comp["label"] : label = comp["title"]

            components_fnames[label] = fname
          elsif comp["file_versions"][0]["file_uri"].include?('_MAS')
            fname = comp["file_versions"][0]["file_uri"].chomp('.jpg').chomp('.tif').chomp('.jp2').chomp('_MAS') + '.jp2'
            comp["label"] ? label = comp["label"] : label = comp["title"]

            components_fnames[label] = fname
          else
            fname = comp["file_versions"][0]["file_uri"].chomp('.jpg').chomp('.tif').chomp('.jp2') + '.jp2'
            comp["label"] ? label = comp["label"] : label = comp["title"]

            components_fnames[label] = fname
          end
        elsif comp["file_versions"].length > 1
          if comp["file_versions"][1]["file_uri"].include?('://')
            fname = comp["file_versions"][0]["file_uri"].split('/').last.chomp('.jpg').chomp('.tif').chomp('.jp2') + '.jp2'
            comp["label"] ? label = comp["label"] : label = comp["title"]

            components_fnames[label] = fname
          else
            fname = comp["file_versions"][1]["file_uri"].chomp('.jpg').chomp('.tif').chomp('.jp2') + '.jp2'
            comp["label"] ? label = comp["label"] : label = comp["title"]

            components_fnames[label] = fname
          end
        end
      end

      components_fnames
    end
  end
end
