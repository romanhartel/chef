node.override['nginx']['port'] = 443
node.override['nginx']['cert'] = '/home/ubuntu/chef-repo/files/domain.crt'
node.override['nginx']['key']  = '/home/ubuntu/chef-repo/files/domain.key'
