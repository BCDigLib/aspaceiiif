require 'iiif/presentation'
require 'rest-client'
require 'json'
require 'yaml'

conf = YAML::load_file('config.yml')
auth_resp = RestClient::Request.execute(method: :post, 
                                       url: conf["aspace_base_uri"] + '/users/admin/login',
                                       payload: {password: conf["aspace_password"]}
)
auth_resp_serialized = JSON.parse(auth_resp)
session_id = auth_resp_serialized["session"]

