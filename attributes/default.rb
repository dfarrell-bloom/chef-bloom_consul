
default[:bloom_consul][:version] = '0.3.0'
# pulling overridden version into this URL requires chef 11+
default[:bloom_consul][:url] = "http://bloom-public-assets.s3.amazonaws.com/consul_#{node[:bloom_consul][:version]}_amd64.deb"

default[:bloom_consul][:config_dir]= '/etc/consul.d'
default[:bloom_consul][:user]= "consul"
default[:bloom_consul][:group]= "consul" 

## Consul Configuration
#  most of these values can be left to "nil" to exclude the setting from the config file, in 
#  which case the values will be the defaults from consul itself.
#  See http://www.consul.io/docs/agent/options.html for more information.

# networking connectivity options
default[:bloom_consul][:config][:bind_addr] = nil
default[:bloom_consul][:config][:client_addr] = nil
default[:bloom_consul][:config][:advertise_addr] = nil
default[:bloom_consul][:config][:ports] = nil
    # could be a hash containing any of dns, http, rpc, serf_lan, serf_wan, server

# common node configuration settings    
default[:bloom_consul][:config][:node_name] = nil
default[:bloom_consul][:config][:datacenter] = nil
default[:bloom_consul][:config][:start_join] = nil
default[:bloom_consul][:config][:bootstrap] = nil
default[:bloom_consul][:config][:server] = nil
default[:bloom_consul][:config][:protocol] = nil
default[:bloom_consul][:config][:check_update_interval] = nil

# options for removing nodes automatically
default[:bloom_consul][:config][:rejoin_after_leave] = nil
default[:bloom_consul][:config][:skip_leave_on_interrupt] = nil
default[:bloom_consul][:config][:leave_on_terminate] = nil

# filesystem locations
# the defaults are defined in keeping with the way the DEB file installs
default[:bloom_consul][:config][:data_dir] = "/var/lib/consul/data"
default[:bloom_consul][:config][:ui_dir] = "/usr/local/share/consul/web"

# logging
default[:bloom_consul][:config][:enable_syslog] = nil
default[:bloom_consul][:config][:syslog_facility] = nil
default[:bloom_consul][:config][:enable_debug] = nil
default[:bloom_consul][:config][:log_level] = nil

# Consul DNS configuration
default[:bloom_consul][:config][:domain] = nil
default[:bloom_consul][:config][:dns_config] = nil
default[:bloom_consul][:config][:recursor] = nil
    # dns_confing can be hash containing any of:
    #     node_ttl, service_ttl, allow_state, max_stale
    # or can be nil to exclude the entire section

# PKI can be used to authorize connections in and out
default[:bloom_consul][:config][:ca_file] = nil
default[:bloom_consul][:config][:cert_file] = nil
default[:bloom_consul][:config][:key_file] = nil
default[:bloom_consul][:config][:verify_incoming] = nil
default[:bloom_consul][:config][:verify_outgoing] = nil

# Encryption can be applied to network traffic
default[:bloom_consul][:config][:encrypt] = nil

