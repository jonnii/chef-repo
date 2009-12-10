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

package "imagemagick"
package "libmagick9-dev"
package "libxml2-dev"
package "libxslt1-dev"

gem_package "rmagick"

gem_package "hoe"

directory "/apps" do
  owner "root"
  group "root"
  action :create
end

user "nycandlove" do
  gid "www-data"
  uid "1000"
  home "/home/nycandlove"
  shell "/bin/sh"
end

directory "/apps/nycandlove" do
  owner "nycandlove"
  group "www-data"
  mode "0755"
  action :create
end

%w(staging production).each do |env|
  directory "/apps/nycandlove/#{env}" do
    owner "nycandlove"
    group "www-data"
    mode "0755"
    action :create
  end
  directory "/apps/nycandlove/#{env}/releases" do
    owner "nycandlove"
    group "www-data"
    mode "0755"
    action :create
  end
  directory "/apps/nycandlove/#{env}/shared" do
    owner "nycandlove"
    group "www-data"
    mode "0755"
    action :create
  end
end 

include_recipe "passenger_apache2::mod_rails"

web_app "nycandlove" do
  cookbook "passenger_apache2"
  docroot "/apps/nycandlove/production/current/public"
  server_name "#{node[:domain]}"
  server_aliases [ "www.nycandlove.com", "nycandlove", node[:hostname] ]
  rails_env "production"
end

web_app "nycandlove_staging" do
  cookbook "passenger_apache2"
  docroot "/apps/nycandlove/staging/current/public"
  server_name "staging.nycandlove.com"
  server_aliases [ "staging.nycandlove" ]
  rails_env "staging"
end

#god_monitor "nycandlove" do
#  config "nycandlove.god.erb"
#end