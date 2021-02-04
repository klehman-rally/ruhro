# ruhro
Ruby scripts using net/http, httpclient, faraday to make HTTP REST requests

Specifically intended to investigate problems related to default / explicitly set use of TLS version when talking to more restrictive web services (currently those restricting to TLS v1.2).

The scripts are an attempt to shine a flashlight on where the problem occurs on Windows platforms when using Ruby 2.2.6.
At inception, it is an open question whether Ruby or net/http or httpclient or OpenSSL are the culprit.

# here is a bogus line in a discardable branch
