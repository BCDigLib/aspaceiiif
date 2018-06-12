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
input_csv = CSV.read('input.csv')

input_csv.each do |row|
end