require 'aspaceiiif/api_utils'

module ASpaceIIIF
  class Records
    def initialize(dig_obj_id)
      @dig_obj_id = dig_obj_id
      @conn = APIUtils.new
    end

    def digital_object
      uri_suffix = '/repositories/2/digital_objects/' + @dig_obj_id
      @conn.get_record(uri_suffix)
    end

    def digital_object_tree
      tree_id = digital_object["tree"]["ref"]
      @conn.get_record(tree_id)
    end

    def archival_object
      arch_obj_id = digital_object["linked_instances"][0]["ref"]
      @conn.get_record(arch_obj_id)
    end

    def resource
      resource_id = archival_object["resource"]["ref"]
      @conn.get_record(resource_id)
    end
  end
end
