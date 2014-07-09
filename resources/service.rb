
actions :create
default_action :create

attribute :name, name_attribute: true, kind_of: String, required: true
attribute :id, kind_of: String
attribute :tags, kind_of: Array, default: []
attribute :port, kind_of: Integer, required: true, callbacks: { 
        "Port must be between 0 and 65535" => lambda { |port| 
            port <= 65335 and port >= 0
        }
    }

attribute :check, kind_of: Hash, default: [], callbacks: {
    "check must be a hash" => lambda { |check|
        check.kind_of? Hash 
    },
    "each check must specify either ttl or script/interval, not both" => lambda { |check|
          ( check.has_key?(:ttl) and 
            ( not ( check.has_key?( :script ) and check.has_key?(:interval) ) )
          ) or ( 
            check.has_key?( :script ) and check.has_key?(:interval) 
          )
    }
}


