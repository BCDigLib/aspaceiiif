require 'aspaceiiif/config'
require 'rest-client'
require 'json'
require_relative 'logging'

module ASpaceIIIF
  class APIUtils
    include Logging

    def initialize
      @conf = Config.load
      @repo_id = @conf['repository']
      auth_resp = RestClient::Request.execute(method: :post, 
                                             url: @conf["aspace_base_uri"] + '/users/admin/login',
                                             payload: { password: @conf["aspace_password"] }
      )
      auth_resp_serialized = JSON.parse(auth_resp)
      @session_id = auth_resp_serialized["session"]
    end

    def get_record(uri_suffix)
      endpoint = @conf["aspace_base_uri"] + uri_suffix
      logger.debug("\turl: #{endpoint}")

      begin
        response = RestClient.get(endpoint, {"X-ArchivesSpace-Session": @session_id})
      rescue RestClient::ExceptionWithResponse => e
        logger.error("#{e.response}")
        return {}
      end
      
      JSON.parse(response)
    end

    def find_digital_objects(resource_id)
      params_array = [
        "resolve[]=tree"
      ]
      params_string = "#{params_array.join("&")}"
      resource_tree_uri_suffix = "/repositories/#{@repo_id}/resources/#{resource_id}?#{params_string}"

      logger.debug("Fetching resource (id: #{resource_id})")
      resource_tree_all = get_record(resource_tree_uri_suffix)

      # pull out resource_tree_all["tree"]["_resolved"] or return an empty hash
      resource_tree = resource_tree_all.dig("tree", "_resolved") || {}

      if resource_tree.empty?
        logger.error("No resource record tree found")
        return {}
      end

      if resource_tree.dig("children").nil?
        logger.warn("No resource record children found")
        return {}
      end

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

      logger.debug("Found #{archival_object_refs.length} child archival object(s):")
      logger.debug("#{'-' * 45}")

      archival_object_refs.map.with_index do |ref, index|
        logger.debug("[#{index + 1}] Fetching archival object (ref: #{ref})")
        archival_object = get_record(ref)
        archival_object["instances"].map { |instance| digital_object_refs << instance["digital_object"]["ref"] if instance["instance_type"] == "digital_object" }
      end

      # Return an array of digital object IDs
      digital_object_refs.map { |ref| ref.split('/').last }
    end
  end
end
