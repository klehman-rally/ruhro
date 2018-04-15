require 'logger'
require 'faraday'

options = { :timeout => 20, 
           :ssl => {:verify => true}
          }
http = Faraday.new() do |builder|
    builder.request  :url_encoded
    builder.response :logger
    builder.adapter  :net_http
    #builder.use Faraday::Response::Logger, Logger.new('faraday.log')
end

http.url_prefix = 'https://rally1.rallydev.com/slm/webservice/v2.0'

rally_name = "klehman@rallydev.com"
rally_pswd = "abc123!!"

http.basic_auth(rally_name, rally_pswd)
http.headers['Content-Type'] = 'application/json'

response = http.get('user')
puts response.status
puts response.inspect
puts response.body


