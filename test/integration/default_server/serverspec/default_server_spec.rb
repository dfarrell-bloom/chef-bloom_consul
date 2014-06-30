
require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "default recipe" do
    describe service("consul") do
        it { should be_running }
    end
    describe command("consul members") do
        [ "alive", "default-server", " server" ].each do |str|
            it { should return_stdout /#{str}/ }
        end
    end
end

