
# Internal resource for testing the service LWRP

include_recipe "bloom_consul::create_user_and_group"
include_recipe "bloom_consul::service"

directory node[:bloom_consul][:config_dir] do
    action :create
    owner node[:bloom_consul][:user]
    group node[:bloom_consul][:group]
    mode 0550
end

bloom_consul_service "webserver" do
    id "websvr01"
    checks [ 
        {
            script: "true",
            interval: "5s"
        }, 
        { 
            ttl: "10s"
        }
    ]
end

bloom_consul_service "webserver2" do
    # we won't set ID here and we'll test name is used properly
    checks [ 
        { ttl: "5s" }, 
        { script: "false", interval: "10s" }
    ]
end
