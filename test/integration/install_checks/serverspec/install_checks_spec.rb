
require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "install_checks recipe" do
   describe file("/opt/consul_checks") do 
        it { should be_directory }
        it { should be_mode 755 }
        it { should be_owned_by "root" }
        it { should be_grouped_into "root" }
   end
end

describe "http-status-check.sh" do
    describe file("/opt/consul_checks/http-status-check.sh") do
        it { should be_file }
        it { should be_mode 755 }
        it { should be_owned_by "root" }
        it { should be_grouped_into "root" }
    end
    # test location/scheme/host/port/timeout from stdout
    describe command("/opt/consul_checks/http-status-check.sh -S ftp -m 1 -p 81 -h no-such-host.moolb.com -l /file.html") do
        it { should return_stdout %r|ftp://no-such-host\.moolb\.com:81/file\.html| }
        it { should return_stdout %r| -m 1 -w | }
        it { should return_exit_status 254 } # curl will fail
    end
    # test a reasonable check of an S3 file 
    describe command("/opt/consul_checks/http-status-check.sh -h s3.amazonaws.com -l /bloom-maintenance/http-test.html") do
        it { should return_stdout /This file is meant for http CURL testing, used in consul tests\.  Please do not delete\.  / }
        it { should return_stdout %r|http://s3\.amazonaws\.com/bloom-maintenance/http-test\.html| }
        it { should return_stdout /Status: 200/ }
        it { should return_exit_status 0 }
    end
    # let's make sure a 404 returns exit status 2
    describe command("/opt/consul_checks/http-status-check.sh -h bloom-maintenance.s3-website-us-east-1.amazonaws.com -l /non-existant.html") do
        it { should return_stdout %r|http://bloom-maintenance\.s3-website-us-east-1.amazonaws\.com/non-existant\.html| }
        it { should return_stdout /Status: 404/ }
        it { should return_exit_status 2 }
    end
    # same thing,but let's say that is the correct status
    describe command("/opt/consul_checks/http-status-check.sh -h bloom-maintenance.s3-website-us-east-1.amazonaws.com -l /non-existant.html -s 404") do
        it { should return_stdout %r|http://bloom-maintenance\.s3-website-us-east-1.amazonaws\.com/non-existant\.html| }
        it { should return_stdout /Status: 404/ }
        it { should return_exit_status 0 }
    end
end
