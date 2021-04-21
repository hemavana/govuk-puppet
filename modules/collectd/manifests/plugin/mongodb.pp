# == Class: collectd::plugin::mongodb
#
# Setup a collectd plugin to monitor MongoDB.
#
class collectd::plugin::mongodb {
  include mongodb::python
  include collectd::plugin::python

  # Attribution: https://github.com/sebest/collectd-mongodb
  # @file { '/usr/lib/collectd/python/mongodb.py':
  #   ensure => present,
  #   source => 'puppet:///modules/collectd/usr/lib/collectd/python/mongodb.py',
  #   tag    => 'collectd::plugin',
  #   notify => File['/etc/collectd/conf.d/mongodb.conf'],
  # }
  #
  # @file { '/usr/lib/collectd/python/mongodb.pyc':
  #   ensure => undef,
  #   tag    => 'collectd::plugin',
  # }
  #
  # @collectd::plugin { 'mongodb':
  #   source  => 'puppet:///modules/collectd/etc/collectd/conf.d/mongodb.conf',
  #   require => Class['collectd::plugin::python'],
  # }
}
