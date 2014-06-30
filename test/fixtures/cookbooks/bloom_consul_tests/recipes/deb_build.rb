
require 'shellwords'

remote_directory "/tmp/consul-deb" do
    source "deb"
end

include_recipe "apt"

%w{ build-essential curl unzip }.each do |pkg|
    package pkg
end

bash "build deb" do
    cwd "/tmp/consul-deb"
    code <<-eof
sed -i -e 's/((VERSION))/#{Shellwords.escape node[:bloom_consul][:version]}/' `grep -rlF '((VERSION))' /tmp/consul-deb`
make
eof
end

