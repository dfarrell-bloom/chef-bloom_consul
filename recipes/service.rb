
# (re)start service

service "consul" do
    provider Chef::Provider::Service::Upstart
    # we must define the service for notified restart upon configuration later.
    action :nothing
    # this should cause a stop-start cycle rather than an inconsistent reboot
    # https://tickets.opscode.com/browse/CHEF-1424
    supports [ :stop, :start, :reload ] 
    # note that reload is not a complete reload, but will pick up 
    # new services and some config changes.  See
    # http://www.consul.io/docs/agent/services.html
    # http://www.consul.io/docs/commands/reload.html
    # http://www.consul.io/docs/agent/options.html
    reload_command "consul reload"
end
