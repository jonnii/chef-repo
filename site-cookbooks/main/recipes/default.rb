#
# Cookbook Name:: main
# Recipe:: default
#
# Copyright 2009, TWENTYTHIRDANDLOVE
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

directory "/apps" do
  owner "root"
  group "root"
  action :create
end

user "twentythirdandlove" do
  gid "www-data"
  uid "1000"
  home "/home/twentythirdandlove"
  shell "/bin/sh"
end

directory "/apps/twentythirdandlove" do
  owner "twentythirdandlove"
  group "www-data"
  mode "0755"
  action :create
end

%w(staging production).each do |env|
  directory "/apps/twentythirdandlove/#{env}" do
    owner "twentythirdandlove"
    group "www-data"
    mode "0755"
    action :create
  end
  directory "/apps/twentythirdandlove/#{env}/releases" do
    owner "twentythirdandlove"
    group "www-data"
    mode "0755"
    action :create
  end
  directory "/apps/twentythirdandlove/#{env}/shared" do
    owner "twentythirdandlove"
    group "www-data"
    mode "0755"
    action :create
  end
end 

include_recipe "rails"
include_recipe "passenger_apache2"

web_app "twentythirdandlove" do
  cookbook "passenger_apache2"
  docroot "/apps/twentythirdandlove/staging/current/public"
  server_name "#{node[:domain]}"
  server_aliases [ "twentythirdandlove", node[:hostname] ]
  rails_env "production"
end