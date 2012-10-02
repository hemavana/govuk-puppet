class loadbalancer::cron {
  file{ '/usr/local/bin/stop_loadbalancer':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/loadbalancer/stop_loadbalancer.sh'
  }

  cron { 'stop-loadbalancer':
    ensure  => present,
    user    => 'root',
    minute  => '*/1',
    command => '/usr/local/bin/stop_loadbalancer',
    require => File['/usr/local/bin/stop_loadbalancer'],
  }
# This is aaded to rectify a copy paste mistake
  cron { 'update-latest-to-mirror':
    ensure  => absent
  }
}