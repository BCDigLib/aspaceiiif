require 'aspaceiiif/records'
require_relative 'logging'

module ASpaceIIIF
  class Metadata
    include Logging

    def initialize(dig_obj_id)
      as_records = Records.new(dig_obj_id)
      @digital_object = as_records.digital_object
      @digital_object_tree = as_records.digital_object_tree
      @digital_object_components = as_records.digital_object_components
      @archival_object = as_records.archival_object
      @resource = as_records.resource
      @linked_agent = as_records.linked_agent
      @digital_object_pk = dig_obj_id

      @conf = Config.load
      @placeholder_text_use_statement = @conf['placeholder_text_use_statement'] || ""
      @placeholder_text_owner = @conf['placeholder_text_owner'] || ""
    end

    def handle
      @digital_object["digital_object_id"]
    end

    def use_statement
      if @digital_object["notes"].select { |note| note["type"] == "userestrict" }.length > 0
        @digital_object["notes"].select { |note| note["type"] == "userestrict" }[0]["content"][0]
      else
        # Use the placeholder use statement
        @placeholder_text_use_statement
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
      # BC Libraries doesn't include an owner field in the record, so just use the placeholder text
      @placeholder_text_owner
    end

    def calculate_component_label(component_label, component_title)
        # Check if component_label is not nil and not an empty string
        if !component_label.nil? && !component_label.empty?
            component_label
        else
            component_title
        end
    end

    def generate_clean_component_file_uri(component_file_uri)
        component_file_uri.split('/').last.chomp('.jpg').chomp('.tif').chomp('.jp2').chomp('_MAS') + '.jp2'
    end

    def component_labels_filenames
      components_fnames = {}

      # Map labels to filenames, accounting for various quirks
      # TODO: refactor for simplicity and clarity once we rebuild legacy DOs
      @digital_object_components.map do |comp|
        # Skip if this component record includes specific title substrings
        comp_title = comp.dig("title") || ""
        next if comp_title.include?('_target') || comp_title.include?('_INT')

        comp_label = comp.dig("label") || ""
        calculated_comp_label = calculate_component_label(comp_label, comp_title)

        comp_file_versions = comp.dig("file_versions") || []
        comp_use_statement = comp.dig("file_versions", 0, "use_statement") || ""
        comp_file_uri = comp.dig("file_versions", 0, "file_uri") || ""
        # TODO: can comp_file_uri be an empty string?

        if comp_use_statement.include?("master") || 
           comp_use_statement.include?("archive") || 
           (comp_file_versions.length == 1 && comp_use_statement.include?("access_copy"))

          components_fnames[calculated_comp_label] = generate_clean_component_file_uri(comp_file_uri)
        elsif comp_file_versions.length > 1
          comp_file_versions_multi = comp.dig("file_versions", 1, "file_uri") || ""

          if !comp_file_versions_multi.include?('://')
            comp_file_uri = comp_file_versions_multi
          end

          components_fnames[calculated_comp_label] = generate_clean_component_file_uri(comp_file_uri)
        end
      end

      components_fnames
    end
  end
end
