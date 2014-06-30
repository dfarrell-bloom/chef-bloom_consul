
# install checks 

directory "/opt/consul_checks/" do 
    owner "root"
    group "root"
    mode "0755"
end

cookbook_file "/opt/consul_checks/http-status-check.sh" do
    owner "root"
    group "root"
    mode "0755"
end

include_recipe "apt"

# required packages
[ 
    "curl", "bc", # http-status-check.rb ( bc used to check validity of some input )
 
].each do |pkg|
    package pkg 
end


