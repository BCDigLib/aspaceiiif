require 'aspaceiiif/api_utils'

module ASpaceIIIF
  class Records
    def initialize(resource_id)
      @resource_id = resource_id
      @conn = APIUtils.new
    end

    def resource
      resource_ref = '/repositories/2/digital_objects/' + @resource_id
      @conn.get_record(resource_ref)
    end

    def resource_tree
      resource_tree_ref = resource["tree"]["ref"]
      @conn.get_record(resource_tree_ref)
    end

    def archival_objects
      resource_components = resource_tree["children"].select { |e| e["children"].any? { |e| e["instance_types"].include?("digital_object") } }[0]["children"]
      arch_obj_refs = resource_components.map { |obj| obj["record_uri"] }
      arch_obj_refs.map { |ref| @conn.get_record(ref) }
    end

    def digital_objects
      dig_obj_instances = archival_objects.map { |obj| obj["instances"].detect { |instance| instance["instance_type"] == "digital_object" } }.compact
      dig_obj_refs = dig_obj_instances.map { |instance| instance["digital_object"]["ref"] }
      dig_obj_refs.map { |ref| @conn.get_record(ref) }
    end

    def digital_object_trees
      dig_obj_tree_refs = digital_objects.map { |obj| obj["tree"]["ref"] }
      dig_obj_tree_refs.map { |ref| @conn.get_record(ref) }
    end

    def digital_object_components
      dig_obj_comp_refs = digital_object_trees.map { |tree| tree["children"].map { |e| e["record_uri"] } }
      dig_obj_comp_refs.map { |ref| @conn.get_record(ref) }
    end

    def linked_agents
      agent_records = {}

      archival_objects.each do |obj|
        unless (obj["linked_agents"].empty? && resource["linked_agents"].empty?)
          if obj["linked_agents"].length > 0 
            agent_ref = obj["linked_agents"].detect { |e| e["role"] == "creator" }["ref"]
            agent_records["#{obj[uri]}"] = @conn.get_record(agent_ref)
          else
            agent_ref = resource["linked_agents"].detect { |e| e["role"] == "creator" }["ref"]
            agent_records["#{obj[uri]}"] = @conn.get_record(agent_ref)
          end
        end
      end

      agent_records
    end
  end
end
