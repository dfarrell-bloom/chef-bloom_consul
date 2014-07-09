
require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "Consul Configuration" do
    describe file("/etc/consul.d/00-config.json") do
        it { should be_file }
        it { should be_mode 440 }
        it { should be_owned_by "consul" }
        it { should be_grouped_into "consul" }
        # we'd expect this to rais no errors
        require 'json'
    end
    describe "File content should match expectations" do
        config = JSON.parse File.read( "/etc/consul.d/00-config.json" )
        config.should == { 
            "node_name"=>"Kitchen Node",
            "bootstrap"=>true,   
            "server"=>true,
            "data_dir" => "/tmp/consul/data",
            "ui_dir" => "/tmp/web/data",
            "bind_addr" => "10.2.3.4",
            "advertise_addr" => "10.2.3.5",
            "client_addr" => "0.0.0.0",
            "log_level" => "trace",
            "encrypt" => "m3FC302X/C/xZw92+p+oIg==",
            "leave_on_terminate" => true,
            "skip_leave_on_interrupt" => true,
            "rejoin_after_leave" => true,
            "enable_debug" => true,
            "enable_syslog" => true, 
            "syslog_facility" => "LOCAL1",
            "datacenter" => "dc1",
            "ca_file" => "/tmp/ca",
            "cert_file" => "/tmp/cert",
            "key_file" => "/tmp/key",
            "verify_incoming" => true,
            "verify_outgoing" => true,
            "ports" => {
                "dns"=>53,
                "http"=>80,
                "serf_lan"=>8601,
                "serf_wan"=>8602,
                "server"=>8603,
                "rpc"=>8604,
            },
            "domain"=> "consul.tld",
            "dns_config" => {
                "service_ttl" => "10s",
                "allow_stale" => true,
                "max_stale" => "5s", 
                "node_ttl" => "10m"
            }
        }
    end
end
