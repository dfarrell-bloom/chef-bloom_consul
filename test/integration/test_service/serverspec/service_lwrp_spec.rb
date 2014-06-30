
require 'serverspec'

require 'json'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "testing recipe" do
    describe file("/etc/consul.d") do
        it { should be_directory }
        it { should be_mode 550 }
        it { should be_owned_by "consul" }
        it { should be_grouped_into "consul" }
    end
end

describe "service resource results for webserver" do
    # this one should be named by the id
    describe file("/etc/consul.d/websvr01.json") do
        it { should be_file }
        it { should be_mode 440 }
        it { should be_owned_by "consul" }
        it { should be_grouped_into "consul" }
        content = JSON::parse ::File.read("/etc/consul.d/websvr01.json")
        # content.should be_a_kind_of(Hash)
        content.should == {"name"=>"webserver", "port"=>nil, "tags"=>nil, "checks"=>[{"script"=>"true", "interval"=>"5s"}, {"ttl"=>"10s"}]}
    end
end

=begin 
# !!!  Update this when the webserver one is complete !!!

describe "service resource results for webserver2" do
    # this one should be named by the name
    describe file("/etc/consul.d/webserver2.json") do
        it { should be_file }
        it { should be_mode 440 }
        it { should be_owned_by "consul" }
        it { should be_grouped_into "consul" }
    end
    
end

=end
