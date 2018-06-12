# Using the API
If you're just getting started, read the [Working with the ArchivesSpace API](https://github.com/BCDigLib/bc-aspace/wiki/Working-with-the-ArchivesSpace-API) 
wiki page. It walks through the basics of the API, including authentication.

We tend to prefer Python and Ruby for data wrangling, but you can use any 
language with an HTTP library to work with the ArchivesSpace API. Even within 
the confines of Ruby and Python, there are many different tools you can use to 
interact with the API. The examples in this repo are intended only as a starting 
point, so feel free to expand on them using the languages and tools you like to 
use for this kind of work.

## Ruby
1. Require the following libraries in your script:
* [rest-client](http://www.rubydoc.info/github/rest-client/rest-client): to make 
http requests to the application. Feel free to use a different HTTP client if 
you prefer; there are plenty of options.
* [json](http://ruby-doc.org/stdlib-2.4.0/libdoc/json/rdoc/JSON.html): to parse 
the JSON returned by the application.
* [yaml](http://ruby-doc.org/stdlib-2.4.0/libdoc/yaml/rdoc/YAML.html): to parse 
a config file
* [csv](http://ruby-doc.org/stdlib-2.4.0/libdoc/csv/rdoc/CSV.html): to write the 
data to CSV. This is purely optional, but many of our use cases involve 
outputting data harvested from the ASpace API to CSV or TSV.

2. Create a basic YAML config file. This will store authentication credentials 
and other params that you can use in your script. See config.yml in this 
directory for a sample file.

3. Authenticate and store the session ID in a variable:
```ruby
conf = YAML::load_file('config.yml')
response = RestClient::Request.execute(method: :post, 
                                       url: conf["base_uri"] + '/users/admin/login',
                                       payload: {password: conf["password"]}
)
body = JSON.parse(response.body)
session_id = body["session"]
```

4. Script away! See the .rb files in this folder for examples. The basic pattern 
is to figure out the endpoint you want, send a request, then parse the response 
into JSON; e.g.:

```ruby
endpoint = conf["base_uri"] + '/repositories/1/resources/1'
response = RestClient.get(endpoint, {"X-ArchivesSpace-Session": session_id})
body = JSON.parse(response.body)
```

You can then parse the response as you would any hash. For example, if you wanted 
to know the title of the resource record that we retrieved above:

```ruby
title = body["title"]
```

Or, let's say you wanted an array containing all of the related accessions:

```ruby
arr = []
body["related_accessions"].each { |pair| arr << pair.values.join }
```

## Python
Details forthcoming. See the [batch DAO workflow](https://github.com/BCDigLib/bc-aspace/tree/master/batch_dao) 
for sample code in Python.
