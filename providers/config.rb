
use_inline_resources

parameters =%w{
    bootstrap
    bind_addr advertise_addr client_addr
    data_dir ui_dir
    node_name datacenter start_join protocol server check_update_interval skip_leave_on_interrupt rejoin_after_leave
    log_level enable_syslog syslog_facility enable_debug
    domain dns_config recursor
    encrypt
    leave_on_terminate
    ca_file cert_file key_file verify_incoming verify_outgoing
    ports
}

action :create do
    require 'json'
    content_data = new_resource.to_hash.select{ |k,v|
        parameters.include? k.to_s 
    }.reject{ 
        |k,v| v == nil 
    }
    
    file ::File.join node[:bloom_consul][:config_dir], "#{ new_resource.filename }" do
        content JSON.pretty_generate content_data
        owner node[:bloom_consul][:user]
        group node[:bloom_consul][:group]
        mode "0440"
        action :create
        # we cannot notify here.  Apparently provider resources can't find
        # external resources 
        # notifies :restart, "service[consul]", :immediately
    end 

    # todo: add whyrun support

end

