# == Class: govuk_containers::ci_postgresql
#
# Install and run a dockerised PostgreSQL 13 server, intended for CI purposes
#
class govuk_containers::ci_postgresql_13(
  $ensure = 'present',
) {
  ::docker::run { 'ci_postgresql_13':
    ensure => $ensure,
    net    => 'host',
    expose => [54313],
    image  => 'postgres:13',
    env    => ['"POSTGRES_HOST_AUTH_METHOD=trust"', '"PGPORT=54313"'],
  }

  @@icinga::check { "check_ci_postgresql_13_running_${::hostname}":
    ensure              => $ensure,
    check_command       => 'check_nrpe!check_proc_running!$ci_postgresql_13',
    service_description => 'Docker PostgreSQL 13 is not running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }
}
