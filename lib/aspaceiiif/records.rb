require 'aspaceiiif/api_utils'

module ASpaceIIIF
  class Records
    include Logging
    
    def initialize(dig_obj_id)
      @conf = Config.load
      @repo_id = @conf['repository']
      @dig_obj_id = dig_obj_id
      @conn = APIUtils.new

      @digital_object_record = nil
    end

    def digital_object
      params_array = [
        "resolve[]=tree",
        "resolve[]=linked_instances::linked_agents",
        "resolve[]=linked_instances::resource::linked_agents"
      ]
      params_string = "#{params_array.join("&")}"
      dig_obj_ref = "/repositories/#{@repo_id}/digital_objects/#{@dig_obj_id}?#{params_string}"

      if @digital_object_record.nil?
        logger.debug("Fetching digital object (id: #{@dig_obj_id})")
        @digital_object_record = @conn.get_record(dig_obj_ref)
      end

      @digital_object_record
    end

    def digital_object_tree
      digital_object.dig("tree", "_resolved") || {}
    end

    def digital_object_components
      digital_object_components = digital_object_tree.dig("children") || {}

      logger.debug("\tfound #{digital_object_components.length} digital object component children")

      digital_object_components
    end

    def archival_object
      digital_object.dig("linked_instances", 0, "_resolved") || {}
    end

    def resource
      # Look for the "resource": {"_resolved": ...} structure in the archival_object to identify the parent resource record,
      # but if that doesn't exist then the archival_object _is_ the resource record
      archival_object.dig("resource", "_resolved") || archival_object
    end

    def linked_agent
      if resource.dig("linked_agents").nil? || resource.dig("linked_agents").empty?
        {}
      else
        resource.dig("linked_agents").detect { |e| e["role"] == "creator" }
      end
    end
  end
end
