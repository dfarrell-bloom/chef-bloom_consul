
require 'serverspec'

require 'json'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "deb build recipe" do
    version = nil
    describe file("/tmp/consul-deb") do
        it { should be_directory }
    end
    # make sure version substitution worked fine
    describe command("grep -r -F '((VERSION))' /tmp/consul-deb") do
        it { should return_exit_status 1 }
    end
    describe file("/tmp/consul-deb/Makefile") do
        its(:content) { should match /version=[0-9.]+/ }
        version=`grep ^version= /tmp/consul-deb/Makefile | sed 's/version=//'`.strip
    end
    describe file("/tmp/consul-deb/out/consul_#{version}_amd64.deb") do
        it { should be_file }
    end
    describe command(" dpkg -i /tmp/consul-deb/out/consul_#{version}_amd64.deb " ) do
        it { should return_exit_status 0 }
    end
    describe command( "consul version" ) do
        it { should return_stdout /^Consul v#{Regexp.escape version}/ }   
    end
    describe file( "/etc/consul.d/00-config.json" ) do
        it { should be_file }
    end
    describe command(" dpkg -r consul " ) do
        it { should return_exit_status 0 }
    end
end


