
def check_ipv4
    lambda { |ip|
        if ip =~ /^([0-9]{1,3}\.){3}[0-9]{1,3}$/ 
            true
        else
            false
        end
    }
end

def check_ipv4_or_nil 
    lambda { |ip| 
        ip.kind_of?(NilClass) ? true : check_ipv4().call( ip )
    }
end

def valid_ttl 
    lambda { |ttl| ( ttl.kind_of?( String ) and ( ttl =~ /^[0-9]+[ms]$/ ) ) ? true : false }
end

def valid_ttl_key key
    lambda { |hash|
        return true unless hash.has_key? key
        return valid_ttl.call(hash[key])
    }
end

def true_false
    lambda { |val| [ TrueClass, FalseClass ].include? val.class }
end

def true_false_key key
    lambda { |hash|
        return true unless hash.has_key?( key )
        return true_false.call( hash[key] )
    }
end

def valid_range min, max 
    lambda { | val|
        val >= min and val <= max
    }
end 

def valid_port min=0, max=65535
    valid_range(min, max)
end

def key_valid_port key, min, max
    lambda { |port|
        return true unless port.has_key? key
        return valid_port(min, max).call port[key]
    }
end
