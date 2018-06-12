# This script was just to add collection identifiers to a CSV of top containers 
# with the 'Retrievx' location. The input CSV, "top_container_retrievx.csv", has 
# three columns, the first of which is the top container ID. We loop through the 
# CSV, using the top container IDs to make API calls, then parse the response to 
# add the associated collection identifiers to a fourth row in an output CSV.

require 'rest-client'
require 'json'
require 'yaml'
require 'csv'

conf = YAML::load_file('config.yml')
response = RestClient::Request.execute(method: :post, 
                                       url: conf["base_uri"] + '/users/admin/login',
                                       payload: {password: conf["password"]}
)
body = JSON.parse(response.body)
session_id = body["session"]
top_container_base_uri = conf["base_uri"] + '/repositories/2/top_containers/'

input_csv = CSV.read("top_container_retrievx.csv")
CSV.open("output.csv", "w") do |csv|
  input_csv.each do |row|
    if row[0] == "top_container_id"
      row[3] = "collection_id"
      csv << row
      next
    end
    endpoint = top_container_base_uri + row[0]
    response = RestClient.get(endpoint, {"X-ArchivesSpace-Session": session_id})
    body = JSON.parse(response.body)
    if body["collection"].nil? || body["collection"].empty?
      row[3] = "unlinked"
      csv << row
    else
      identifier = body["collection"][0]["identifier"]
      row[3] = identifier
      csv << row
    end
  end
end
