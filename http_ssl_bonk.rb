
require 'json'

require 'net/https'

RALLY    = "https://rally1.rallydev.com/slm"
USERNAME = ''
PASSWORD = ''

TARGET = "webservice/v2.0/user"

DONT_BOTHER = OpenSSL::SSL::VERIFY_NONE   # what it is in rally_rest_api and rally_api
VERIFY_PEER = OpenSSL::SSL::VERIFY_PEER

TLS         = :TLSv1   # even more modern...

TEN_SECONDS  =  10
FIVE_MINUTES = 300

#############################################################
#
#    direct use of net/https substrate used by rally_rest_api
#
#############################################################

uri = URI.parse(RALLY)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.ssl_version  = TLS
http.verify_mode  = DONT_BOTHER
http.read_timeout = FIVE_MINUTES
#http.ca_file = "My CA cert file"
http.ca_file = '/Users/klehman/CA/certs/cacert.pem' # or "path/to/my/CA/cacert.pem"

url = "%s/%s" % [RALLY, TARGET]
puts "issuing GET for %s" % url
request = Net::HTTP::Get.new(url)

request.basic_auth USERNAME, PASSWORD
request.content_type = 'application/json'
response = http.request(request)
puts response.code
doc = JSON.parse(response.body)
user = doc["User"]
puts "#{user["FirstName"]} #{user["LastName"]}   with official UserName of: #{user["UserName"]}"


##########################################################
#
#    direct use of httpclient substrate used by rally_api
#
##########################################################

require 'httpclient'

rally_http_client = HTTPClient.new()
rally_http_client.set_basic_auth(RALLY, USERNAME, PASSWORD)
rally_http_client.ssl_config.verify_mode = DONT_BOTHER
rally_http_client.receive_timeout = FIVE_MINUTES
rally_http_client.send_timeout    = FIVE_MINUTES
rally_http_client.protocol_retry_count = 2

response = rally_http_client.request('GET', "%s/%s" % [RALLY, TARGET])
puts "#{response.status_code} #{response.reason}"
puts response.peer_cert.inspect

doc = JSON.parse(response.content)
user = doc["User"]
puts "#{user["FirstName"]} #{user["LastName"]}   with official UserName of: #{user["UserName"]}"
