#
# Cookbook Name:: bloom_consul
# Recipe:: default
#

include_recipe "bloom_consul::service"
include_recipe "bloom_consul::install"
include_recipe "bloom_consul::install_checks"
include_recipe "bloom_consul::configure"
