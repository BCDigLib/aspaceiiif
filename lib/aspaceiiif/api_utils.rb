require 'aspaceiiif/config'
require 'rest-client'
require 'json'

module ASpaceIIIF
  class APIUtils
    def initialize
      @conf = Config.load
      auth_resp = RestClient::Request.execute(method: :post, 
                                             url: @conf["aspace_base_uri"] + '/users/admin/login',
                                             payload: { password: @conf["aspace_password"] }
      )
      auth_resp_serialized = JSON.parse(auth_resp)
      @session_id = auth_resp_serialized["session"]
    end

    def get_record(uri_suffix)
      endpoint = @conf["aspace_base_uri"] + uri_suffix
      response = RestClient.get(endpoint, {"X-ArchivesSpace-Session": @session_id})
      JSON.parse(response)
    end

    def find_digital_objects(resource_id)
      resource_tree_uri_suffix = '/repositories/2/resources/' + resource_id + '/tree'
      resource_tree = get_record(resource_tree_uri_suffix)

      archival_object_refs = []
      digital_object_refs = []

      # TODO: refactor for efficiency
      resource_tree["children"].map do |child|
        if child["has_children"] == true
          child["children"].map do |child|
            archival_object_refs << child["record_uri"] if child["instance_types"].include?("digital_object")
            if child["has_children"] == true
              child["children"].map do |child|
                archival_object_refs << child["record_uri"] if child["instance_types"].include?("digital_object")
                if child["has_children"] == true
                  child["children"].map do |child|
                    archival_object_refs << child["record_uri"] if child["instance_types"].include?("digital_object")
                    if child["has_children"] == true
                      child["children"].map do |child|
                        archival_object_refs << child["record_uri"] if child["instance_types"].include?("digital_object")
                        if child["has_children"] == true
                          child["children"].map do |child|
                            archival_object_refs << child["record_uri"] if child["instance_types"].include?("digital_object")
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        elsif child["instance_types"].include?("digital_object")
          archival_object_refs << child["record_uri"] if child["instance_types"].include?("digital_object")
        end
      end

      archival_object_refs.map do |ref|
        archival_object = get_record(ref)
        archival_object["instances"].map { |instance| digital_object_refs << instance["digital_object"]["ref"] if instance["instance_type"] == "digital_object" }
      end

      digital_object_refs.map { |ref| ref.split('/').last }
    end
  end
end
