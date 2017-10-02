cookbook_path    ["/home/ubuntu/chef-repo/cookbooks", "home/ubuntu/chef-repo/site-cookbooks"]
node_path        "/home/ubuntu/chef-repo/nodes"
role_path        "/home/ubuntu/chef-repo/roles"
environment_path "/home/ubuntu/chef-repo/environments"
data_bag_path    "/home/ubuntu/chef-repo/data_bags"
#encrypted_data_bag_secret "data_bag_key"

knife[:berkshelf_path] = "/home/ubuntu/chef-repo/cookbooks"
Chef::Config[:ssl_verify_mode] = :verify_peer if defined? ::Chef
