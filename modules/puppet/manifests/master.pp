class puppet::master {
  if ($::govup_platform == 'preview') {
    include apt

    apt::deb_repository {'puppetlabs-repo':
      url      => 'http://apt.puppetlabs.com',
      repo     => 'main',
      key_url  => 'http://apt.puppetlabs.com/keyring.gpg',
      key_name => 'puppetlabs-key'
    }
    package { 'puppetdb-terminus':
      ensure  => present,
      require => Apt::Deb_repository['puppetlabs-repo']
    }
    file {'/etc/puppet/puppetdb.conf':
      source => 'puppet:///modules/puppet/etc/puppet/puppetdb.conf'
    }
    file {'/etc/puppet/routes.yaml':
      source => 'puppet:///modules/puppet/etc/puppet/routes.yaml'
    }
  }
  file { '/etc/init/puppetmaster.conf':
    require => Package['puppet'],
    source  => 'puppet:///modules/puppet/etc/init/puppetmaster.conf',
  }

  service { 'puppetmaster':
    ensure   => running,
    provider => upstart,
    require  => File['/etc/init/puppetmaster.conf'],
  }
}
