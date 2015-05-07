#
# Cookbook Name:: davis-workshift-website
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apache2'
include_recipe 'apache2::mod_ssl'

secret = Chef::EncryptedDataBagItem.load_secret(node[:bsc_scheduler][:key_path])
private_bits = Chef::EncryptedDataBagItem.load("bsc_scheduler", "private", secret)

# django app user and db user
workshift_db = 'workshift'
workshift_user = workshift_db + '_admin'

user workshift_user do
  system true
  shell '/sbin/nologin'
  action :create
end

simple_iptables_rule "http" do
  rule "--proto tcp --dport 80"
  jump "ACCEPT"
end

if node[:bsc_scheduler][:ssl_enabled]
  simple_iptables_rule "https" do
    rule "--proto tcp --dport 443"
    jump "ACCEPT"
  end
end

superuser_postgresql_connection = {
  :host => 'localhost',
  :username => 'postgres',
  :password => node[:postgresql][:password][:postgres]
}

postgresql_database workshift_db do
  connection(
    :host => '127.0.0.1',
    :username => 'postgres',
    :password => node[:postgresql][:password][:postgres]
  )
  action :create
end

postgresql_database_user workshift_user do
  connection superuser_postgresql_connection
  password private_bits['postgres_password']
  action     :create
end

postgresql_database_user workshift_user do
  connection    superuser_postgresql_connection
  database_name workshift_db
  privileges    [:all]
  action        :grant
end

application 'bsc_scheduler' do
  path node[:bsc_scheduler][:site_root]
  owner node[:apache][:user]
  group node[:apache][:group]
  repository node[:bsc_scheduler][:repo]
  revision node[:bsc_scheduler][:app_version]
  rails do
    database do
      database workshift_db
      username workshift_user
      password private_bits['postgres_password']
    end
  end
end
