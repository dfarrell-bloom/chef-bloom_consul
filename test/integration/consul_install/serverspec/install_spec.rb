
require 'serverspec'

require 'uri'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "package install" do

    describe command("test -e /tmp/consul*.deb") do
        it { should return_exit_status 1 }
    end
    describe command("consul version ") do 
        it { should return_exit_status 0 } 
        it { should return_stdout /^Consul v([0-9.]+){1,}[0-9]+/ }
    end
    describe file( "/etc/consul.d/00-config.json" ) do
        it { should be_file }
    end
end

