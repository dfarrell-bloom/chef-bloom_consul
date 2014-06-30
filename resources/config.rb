
actions :create
default_action :create

# http://www.consul.io/docs/agent/options.html

attribute :filename, kind_of: String, name_attribute: true, required: true, default: "00-config.json"

attribute :bootstrap, kind_of: [ TrueClass, FalseClass ], default: false
attribute :bind_addr, kind_of: [ String, NilClass ], default: nil, callbacks:{
    "bind_addr must be an IP Address or Nil" => check_ipv4_or_nil
}
attribute :advertise_addr, kind_of: [String, NilClass], default: nil, callbacks:{
    "advertise_addr must be an IP Address or Nil" => check_ipv4_or_nil
}
attribute :client_addr, kind_of: [String, NilClass], default: nil, callbacks:{
    "client_addr must be an IP Address or Nil" => check_ipv4_or_nil
}
attribute :data_dir, kind_of: String, default: "/var/lib/consul/data"
attribute :ui_dir, kind_of: String, default: "/usr/share/consul/web"
attribute :datacenter, kind_of: [String,NilClass], default: nil
attribute :log_level, kind_of: [String,NilClass], default: nil, callbacks: {
    "log_level must be nil or a valid log level" => lambda { |ll|
        ll.kind_of?(NilClass) or %w{ trace debug info warn err }.include?(ll)
    }
}
attribute :start_join, kind_of: [ Array, String, NilClass ], default: nil, callbacks: {
    "start_join can be an IP address, an array of IP Addresses, or nil ( no join )" =>
    lambda { |join|
        return true if join.kind_of? NilClass
        return true if join.kind_of? String and check_ipv4().call( join )
        return true if join.kind_of? Array and join.select{ |j|
            check_ipv4().call( j ) == false
        }.count == 0
        return false
    }
}
attribute :node_name, kind_of: [ String, NilClass ], default: nil
attribute :protocol, kind_of: [ String, NilClass ], default: nil
attribute :rejoin_after_leave, kind_of: [ NilClass, TrueClass, FalseClass ], default: nil
attribute :server, kind_of: [ NilClass, TrueClass, FalseClass ], default: nil
attribute :enable_syslog, kind_of: [ NilClass, TrueClass, FalseClass ], default: nil
attribute :syslog_facility, kind_of: [ NilClass, String ], default: nil
attribute :domain, kind_of: [ String, NilClass ], default: nil
attribute :check_update_interval, kind_of: [ String, NilClass ], default: nil, callbacks: {
    "should be valid TTL of Seconds or minutes" => lambda { |ttl|
        ttl =~ /^[0-9]+[sm]$/
    }
}
attribute :dns_config, kind_of: [ Hash, NilClass ], default: nil, callbacks: {
    "should be nil or hash containing only known parameters" => lambda {|config|
        return true if config == nil
        return false unless config.kind_of? Hash
        return config.reject{ |k,v| ["node_ttl", "service_ttl", "allow_stale", "max_stale" ].include? k }.count == 0
    },
    "node_ttl, if provided, must be a valid TTL ( [0-9]+[ms] )"     => valid_ttl_key("node_ttl"),
    "service_ttl, if provided, must be a valid TTL ( [0-9]+[ms] )"  => valid_ttl_key("service_ttl"),
    "allow_stale, if provided, must be true or false"         => true_false_key("allow_stale"),
    "max_stale, if provided, must be a valid TTL ( [0-9]+[ms] )"    => valid_ttl_key("max_stale")
}

attribute :enable_debug, kind_of: [ TrueClass, FalseClass, NilClass ], default: nil
attribute :encrypt, kind_of: [ String, NilClass ], default: nil, callbacks: {
    "must be nil or a valid 16 byte Base64-encoded string"=> lambda { |encrypt|
        return true if encrypt == nil
        # http://stackoverflow.com/questions/475074/regex-to-parse-or-validate-base64-data
        return ( encrypt =~ /^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=)?$/ ) ? true : false
   }
}
attribute :recursor, kind_of: [ TrueClass, FalseClass, NilClass ], default: nil
attribute :skip_leave_on_interrupt, kind_of: [ TrueClass, FalseClass, NilClass], default: nil
attribute :leave_on_terminate, kind_of: [ TrueClass, FalseClass, NilClass], default: nil

attribute :ca_file, kind_of: [ NilClass, String ], default: nil
attribute :cert_file, kind_of: [ NilClass, String ], default: nil
attribute :key_file, kind_of: [ NilClass, String ], default: nil
attribute :verify_incoming, kind_of: [ NilClass, TrueClass, FalseClass ], default: nil
attribute :verify_outgoing, kind_of: [ NilClass, TrueClass, FalseClass ], default: nil
attribute :ports, kind_of: [ NilClass, Hash ], default: nil, callbacks: { 
    "ports must either be nil or hash with valid sections dns, http, rpc, serf_lan, serf_wan, & server, each of which must be valid port number " => lambda { |ports|
        return true if ports == nil
        return false unless ports.kind_of? Hash
        return ports.reject{|k,v| [ "dns", "http", "rpc", "serf_lan", "serf_wan", "server" ].include? k }.count == 0
    },
    "dns, if provided, must be valid port between -1 and 65535" => key_valid_port(:dns, -1, 65535),
    "http, if provided, must be valid port between -1 and 65535" => key_valid_port(:http, -1, 65535),
    "rpc, if provided, must be valid port between 0 and 65535" => key_valid_port(:rpc, 0, 65535),
    "serf_lan, if provided, must be valid port between 0 and 65535" => key_valid_port(:serf_lan, 0, 65535),
    "serf_wan, if provided, must be valid port between 0 and 65535" => key_valid_port(:serf_wan, 0, 65535),
    "server, if provided, must be valid port between 0 and 65535" => key_valid_port(:server, 0, 65535)
}
