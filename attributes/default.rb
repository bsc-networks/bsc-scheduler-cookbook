default[:bsc_scheduler][:repo] = 'https://github.com/bsc-networks/workshift_website.git'

# path on the host where the secret key for the (bsc_scheduler, private)
# encrypted data bag item lives
# default: /etc/chef/keys/bsc_scheduler_private.key
default[:bsc_scheduler][:key_path] = '/etc/chef/keys/bsc_scheduler_private.key'

default[:bsc_scheduler][:site_root] = '/usr/local/bsc_scheduler'

default[:bsc_scheduler][:ssl_enabled] = false

default[:bsc_scheduler][:ssl_cert_file] = '/etc/ssl/server.crt'
default[:bsc_scheduler][:ssl_key_file] = '/etc/ssl/server.key'

default[:selinux][:state] = 'permissive'

