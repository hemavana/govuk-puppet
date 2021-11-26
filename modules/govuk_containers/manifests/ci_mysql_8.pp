# == Class: govuk_containers::ci_mysql_8
#
# Install and run a dockerised MySQL 8 server, intended for CI purposes
#
class govuk_containers::ci_mysql_8(
  $ensure = 'present',
) {
  ::docker::run { 'ci_mysql_8':
    ensure  => $ensure,
    net     => 'host',
    expose  => [33068],
    image   => 'mysql:8',
    env     => ['"MYSQL_ROOT_PASSWORD=root"', '"MYSQL_TCP_PORT=33068"'],
    command => '--default-authentication-plugin=mysql_native_password',
  }

  @@icinga::check { "check_ci_mysql_8_running_${::hostname}":
    ensure              => $ensure,
    check_command       => 'check_nrpe!check_proc_running!ci_mysql_8',
    service_description => 'Docker MySQL 8 is not running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }
}
