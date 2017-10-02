template "/etc/nginx/sites-available/proxy" do
  source "proxy.erb"
  user 'www-data'
  group 'www-data'
  variables({
    :port => node['nginx']['port'],
    :hostname => node['hostname'],
    :dir => node['nginx']['log_dir'],
    :root => node['nginx']['default_root'],
    :localhost => 'http://127.0.0.1:4242'
  })
  notifies :restart, resources(:service => "nginx")
  action :create
end

#

service "nginx" do
  action [ :enable, :start ]
end

# sudo ln -s /etc/nginx/sites-available/proxy /etc/nginx/sites-enabled/proxy

link '/etc/nginx/sites-enabled/proxy' do
  to '/etc/nginx/sites-available/proxy'
  link_type :symbolic
  action :create
end
