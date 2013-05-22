class nginx::config ($server_names_hash_max_size) {

  file { '/etc/nginx':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/nginx/etc/nginx';
  }

  file { '/etc/nginx/nginx.conf':
    ensure  => present,
    content => template('nginx/etc/nginx/nginx.conf.erb'),
  }
  nginx::log {
    'json.event.access.log':
      json          => true,
      logstream     => true,
      statsd_metric => "${::fqdn_underscore}.nginx_logs.default.http_%{@fields.status}";
    'access.log':
      logstream => false;
    'error.log':
      logstream => true;
  }

  file { ['/etc/nginx/sites-enabled', '/etc/nginx/sites-available']:
    ensure  => directory,
    recurse => true, # enable recursive directory management
    purge   => true, # purge all unmanaged junk
    force   => true, # also purge subdirs and links etc.
    require => File['/etc/nginx'];
  }

  file { '/etc/nginx/mime.types':
    ensure  => present,
    source  => 'puppet:///modules/nginx/etc/nginx/mime.types',
    require => File['/etc/nginx'],
    notify  => Class['nginx::service'];
  }

  file { '/etc/logrotate.d/nginx':
    ensure => present,
    source => 'puppet:///modules/nginx/etc/logrotate.d/nginx',
  }

  file { ['/var/www', '/var/www/cache']:
    ensure => directory,
    owner  => 'www-data',
  }

  file { '/var/www/error':
    ensure  => directory,
    source  => 'puppet:///modules/nginx/error',
    purge   => true,
    recurse => true,
    force   => true,
    require => File['/var/www'],
  }

  @@nagios::check::graphite { "check_nginx_active_connections_${::hostname}":
    target    => "${::fqdn_underscore}.nginx.nginx_connections-active",
    warning   => 500,
    critical  => 1000,
    desc      => 'nginx high active conn',
    host_name => $::fqdn,
  }

}
