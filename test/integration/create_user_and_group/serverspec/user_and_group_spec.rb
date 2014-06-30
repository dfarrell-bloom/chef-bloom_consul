
require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "consul user and group" do
    describe group("consul") do
        it { should exist }
    end
    describe user("consul") do
        it { should exist }
        it { should belong_to_group "consul" } 
    end
end
