
# Configures consul and (re)starts

# consul must be installed for restart service
include_recipe "bloom_consul::install"
include_recipe "bloom_consul::service"

bloom_consul_config "00-config.json" do 
    action :create
    node[:bloom_consul][:config].each do |key,value|
        send( key, value )
    end
    notifies :restart, "service[consul]", :immediately
end
