
require 'json'

require 'net/https'
require 'pp'

RALLY    = "https://rally1.rallydev.com/slm"
USERNAME = 'foobar@grokomius.org'
PASSWORD = 'wackAHd00813!'

TARGET = "webservice/v2.0/user"

DONT_BOTHER = OpenSSL::SSL::VERIFY_NONE   # what it is in rally_rest_api and rally_api
VERIFY_PEER = OpenSSL::SSL::VERIFY_PEER

TLS_BASIC   = :TLSv1     # superseded ...
TLS_DEPREC  = :TLSv1_1   # on it's way out...
TLS_CURRENT = :TLSv1_2   # with TLS v1.3 in testing its days are numbered

TEN_SECONDS  =  10
FIVE_MINUTES = 300

#############################################################
#
#    direct use of net/https substrate used by rally_rest_api
#
#############################################################

#uri = URI.parse(RALLY)
#http = Net::HTTP.new(uri.host, uri.port)
#http.use_ssl = true
#http.ssl_version  = TLS_CURRENT
#http.verify_mode  = VERIFY_PEER
#http.read_timeout = TEN_SECONDS
##http.ca_file = "My CA cert file"
#http.ca_file = '/Users/klehman/CA/certs/cacert.pem' # or "path/to/my/CA/cacert.pem"

#url = "%s/%s" % [RALLY, TARGET]
#puts "issuing GET for %s" % url
#request = Net::HTTP::Get.new(url)
#
#request.basic_auth USERNAME, PASSWORD
#request.content_type = 'application/json'
#response = http.request(request)
#puts response.code
#doc = JSON.parse(response.body)
#user = doc["User"]
#puts "#{user["FirstName"]} #{user["LastName"]}   with official UserName of: #{user["UserName"]}"
#
#
puts "OpenSSL::SSL::SSLContext settings before..."
puts OpenSSL::SSL::SSLContext::DEFAULT_PARAMS


OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:options] |= OpenSSL::SSL::OP_NO_SSLv2
OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:options] |= OpenSSL::SSL::OP_NO_SSLv3
OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:options] |= OpenSSL::SSL::OP_NO_COMPRESSION
OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = "TLSv1_2"
OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ciphers]     = "TLSv1.2:!aNULL:!eNULL"

puts "\nOpenSSL::SSL::SSLContext settings after..."
puts OpenSSL::SSL::SSLContext::DEFAULT_PARAMS


puts "---------------------------------------------------------------------"
SSL_CHECK_SITE = "https://www.howsmyssl.com"
SSL_CHECK_ENDPOINT = "a/check"
uri = URI.parse(SSL_CHECK_SITE)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
#http.ssl_version  = TLS_CURRENT
http.verify_mode  = VERIFY_PEER
http.read_timeout = TEN_SECONDS
url = "%s/%s" % [SSL_CHECK_SITE, SSL_CHECK_ENDPOINT]
puts "issuing GET for %s" % url
request = Net::HTTP::Get.new(url)
response = http.request(request)
puts response.code
doc = JSON.parse(response.body)
puts "TLS     version: #{doc['tls_version']}"
puts "TLS compression: #{doc['tls_compression_supported']}"
puts "insecure cipher suites: #{doc['insecure_cipher_suites']}"
puts "Rating : #{doc['rating']}"
puts "---------------------------------------------------------------------"

##########################################################
#
#    direct use of httpclient substrate used by rally_api
#
##########################################################

require 'httpclient'

rally_http_client = HTTPClient.new()
rally_http_client.set_basic_auth(RALLY, USERNAME, PASSWORD)
rally_http_client.ssl_config.verify_mode = VERIFY_PEER
rally_http_client.ssl_config.ssl_version = TLS_CURRENT
rally_http_client.receive_timeout = TEN_SECONDS
rally_http_client.send_timeout    = TEN_SECONDS
rally_http_client.protocol_retry_count = 2

response = rally_http_client.request('GET', "%s/%s" % [RALLY, TARGET])
puts "#{response.status_code} #{response.reason}"
puts response.peer_cert.inspect

doc = JSON.parse(response.content)
user = doc["User"]
puts "#{user["FirstName"]} #{user["LastName"]}   with official UserName of: #{user["UserName"]}"
