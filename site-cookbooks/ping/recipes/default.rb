uri = 'http://www.ergsergergerg.ger'

http_request 'head' do
  url uri
  message ''
  headers({
    "Connection" => "Keep-Alive",
    "Keep-Alive" => "Keep-Alive: timeout=5, max=2",
  })
  notifies :post, 'http_request[post]', :immediate
  action :head
end

# Conditional HTTP request

http_request 'post' do
  url uri
  message ({:some => 'data'}.to_json)
  action :post
end
