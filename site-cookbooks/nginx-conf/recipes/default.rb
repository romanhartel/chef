# Install htpasswd

execute 'install' do
  command 'npm install -g htpasswd'
end

#

execute 'htpasswd' do
  command 'htpasswd -bc /home/ubuntu/chef-repo/files/.htpasswd foo bar'
end

# Generate SSL self-signed certificate

execute 'openssl' do
  command 'openssl req -newkey rsa:2048 -nodes -keyout /home/ubuntu/chef-repo/files/domain.key -x509 -days 365 -out /home/ubuntu/chef-repo/files/domain.crt -subj "/C=FR/ST=IDF/L=Paris/O=Paris Company/CN=pariscompany.com"'
end

#

template '/etc/nginx/sites-available/proxy' do
  source 'proxy.erb'
  user 'www-data'
  group 'www-data'
  variables({
    :port => node['nginx']['port'],
    :hostname => node['hostname'],
    :dir => node['nginx']['log_dir'],
    :cert => node['nginx']['cert'],
    :key => node['nginx']['key'],
    :localhost => 'http://127.0.0.1:4242'
  })
  notifies :restart, resources(:service => 'nginx')
  action :create
end

#

service 'nginx' do
  action [ :enable, :start ]
end

# sudo ln -s /etc/nginx/sites-available/proxy /etc/nginx/sites-enabled/proxy

link '/etc/nginx/sites-enabled/proxy' do
  to '/etc/nginx/sites-available/proxy'
  link_type :symbolic
  action :create
end
