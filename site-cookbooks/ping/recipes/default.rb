uri = 'https://' + node['hostname']

http_request 'head' do
  url uri
  message ''
  headers({
    "Authorization" => "Basic Zm9vOmJhcg==",
    "Connection" => "Keep-Alive",
    "Keep-Alive" => "Keep-Alive: timeout=5, max=2",
  })
  notifies :post, 'http_request[post]', :immediate
  action :head
end

# Conditional HTTP request

http_request 'post' do
  url uri
  message 'whatever'
  headers({
    "Authorization" => "Basic Zm9vOmJhcg=="
  })
  action :post
end
