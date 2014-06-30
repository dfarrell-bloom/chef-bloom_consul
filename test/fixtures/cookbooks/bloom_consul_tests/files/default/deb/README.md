
Borrowed from https://github.com/charliek/build-files/blob/master/deb/consul, this Makefile 
packages the upstream builds from https://dl.bintray.com/mitchellh/consul/... and builds a deb file

# How to Push to S3

If you build a new deb you'll want to push it to S3.  

```
wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
unzip awscli-bundle.zip
cd awscli-bundle/
./install
PATH=/home/vagrant/.local/lib/aws/bin/:$PATH
aws configure
# add key and secret
aws s3 cp /tmp/consul-deb/out/consul_*_amd64.deb s3://bloom-public-assets/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
# file will be publicly accessible at 
# http://bloom-public-assets.s3.amazonaws.com/consul_*_amd64.deb
```
