require 'aspaceiiif/api_utils'

module ASpaceIIIF
  class Records
    def initialize(dig_obj_id)
      @dig_obj_id = dig_obj_id
      @conn = APIUtils.new
    end

    def digital_object
      dig_obj_ref = '/repositories/2/digital_objects/' + @dig_obj_id
      @conn.get_record(dig_obj_ref)
    end

    def digital_object_tree
      dig_obj_tree_ref = digital_object["tree"]["ref"]
      @conn.get_record(dig_obj_tree_ref)
    end

    def digital_object_components
      dig_obj_comp_refs = digital_object_tree["children"].map { |e| e["record_uri"] }
      dig_obj_comp_refs.map { |uri| @conn.get_record(uri) }
    end

    def archival_object
      arch_obj_ref = digital_object["linked_instances"][0]["ref"]
      @conn.get_record(arch_obj_ref)
    end

    def resource
      resource_ref = archival_object["resource"]["ref"]
      @conn.get_record(resource_ref)
    end

    def linked_agent
      unless (archival_object["linked_agents"].empty? && resource["linked_agents"].empty?)
        if archival_object["linked_agents"].length > 0 
          agent_ref = archival_object["linked_agents"].detect { |e| e["role"] == "creator" }["ref"]
          @conn.get_record(agent_ref)
        else
          agent_ref = resource["linked_agents"].detect { |e| e["role"] == "creator" }["ref"]
          @conn.get_record(agent_ref)
        end
      end
    end
  end
end