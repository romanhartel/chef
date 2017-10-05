execute 'install' do
  command 'npm install -g node-static'
end

# sudo touch /etc/systemd/system/static.service
# sudo chmod 664 /etc/systemd/system/static.service
# copy service_definition content

file '/etc/systemd/system/static.service' do
  owner 'root'
  group 'root'
  mode '0644'
  content '[Unit]
Description=This is node static!
After=network.target

[Service]
ExecStart=/usr/bin/static /home/ubuntu/log/chef_install.log -p 4242
Type=simple
PIDFile=/tmp/static.pid

[Install]
WantedBy=default.target'
  action :create
end

# sudo systemctl daemon-reload

execute 'reload' do
  command 'sudo systemctl daemon-reload'
end

# sudo systemctl start static.service

execute 'start' do
  command 'sudo systemctl start static.service'
end
