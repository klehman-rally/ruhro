require 'logger'
require 'faraday'

options = { :timeout => 6, 
            :ssl => {:verify => true, :version => :TLS_v1_1}
          }
http = Faraday.new() do |builder|
    builder.request :url_encoded
    builder.use Faraday::Response::Logger, Logger.new('faraday.log')
    builder.adapter :net_http
    builder.options = options
end

http.url_prefix = 'https://rally1.rallydev.com/slm/webservice/v2.0'

good_name = 'nucleotide@rancouruos-isolafiarbond.com'
#bad_pswd  = 'Just4Luck'
#good_pswd = 'Just4Rally'
#bad_pswd  = 'Just4Luck'
good_pswd = 'goober99'

#http.basic_auth(good_name, bad_pswd)
http.basic_auth(good_name, good_pswd)
http.headers['Content-Type'] = 'application/json'

response = http.get('Subscription.js?fetch=Name,Workspaces,Workspace&pretty=true')
puts response.inspect
puts response.status
puts response.body


