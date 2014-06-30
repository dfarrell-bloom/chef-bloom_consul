
# install consul from the specified remote deb package 

include_recipe "bloom_consul::create_user_and_group"

require 'uri'
node.set[:bloom_consul][:debfile] = ::File.join [ 
    "/tmp", 
    ::File.basename( URI.parse(node[:bloom_consul][:url]).path ) 
]

remote_file node[:bloom_consul][:debfile] do
    source node[:bloom_consul][:url]
end

dpkg_package "consul" do
    source node[:bloom_consul][:debfile]
    action :install
end

file node[:bloom_consul][:debfile] do
    action :delete
end

directory node[:bloom_consul][:config_dir] do
    owner node[:bloom_consul][:user]
    group node[:bloom_consul][:group]
    recursive true
    mode 0550
end
directory node[:bloom_consul][:config][:ui_dir] do
    owner node[:bloom_consul][:user]
    group node[:bloom_consul][:group]
    recursive true
    mode 0550
end
directory node[:bloom_consul][:config][:data_dir] do
    owner node[:bloom_consul][:user]
    group node[:bloom_consul][:group]
    recursive true
    mode 0750
end
