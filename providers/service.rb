
use_inline_resources

action :create do
    require 'json'
    content_data = Hash.new
    [ :name, :port, :tags, :checks ].each do |key|
        resource_hash ||= new_resource.to_hash # todo: verify this worsk with test
        content_data[key] = resource_hash[key]
    end
    file ::File.join node[:bloom_consul][:config_dir], "#{new_resource.id || new_resource.name}.json" do
        content content_data.to_json
        owner node[:bloom_consul][:user]
        group node[:bloom_consul][:group]
        mode "0440"
        # we can't notify here.  Apparently resources in providers
        # cannot notify resources outside providers
        # notifies :reload, "service[consul]", :delayed
    end 
    
    
    # todo: add whyrun support

end


