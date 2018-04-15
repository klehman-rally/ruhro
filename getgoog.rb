require 'net/http'
#require 'uri'
require 'json'
require 'pp'

###########################################################################################


def main(nothing)
    uri = URI.parse("http://www.google.com")
    puts "uri.host: %s" % uri.host
    puts "uri.port: %s" % uri.port
    http = Net::HTTP.new(uri.host, uri.port)

    result = processRequest(http, '/') 
    puts result
end
 
###########################################################################################

def processRequest(http, req_url)
    request = Net::HTTP::Get.new(req_url)
    response = http.request(request)
    puts response.code
    puts "-" * 80
    doc = JSON.parse(response.body)
    return doc
end

###########################################################################################
###########################################################################################


main(nil)

