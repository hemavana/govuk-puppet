define govuk::procfile::worker (
  $setenv_as = $title
) {
  include govuk::procfile

  $service_name = "${title}-procfile-worker"
  $enable_service = $::govuk_platform ? {
    'development' => false,
    default       => true,
  }

  file { "/etc/init/${service_name}.conf":
    ensure    => present,
    content   => template('govuk/procfile-worker.conf.erb'),
    notify    => Service[$service_name],
    subscribe => Class['Govuk::Procfile'],
  }

  service { $service_name:
    ensure  => $enable_service,
  }

  if $enable_service {
    @@icinga::check { "check_app_${title}_procfile_worker_upstart_up_${::hostname}":
      check_command       => "check_nrpe!check_upstart_status!${service_name}",
      service_description => "${title} procfile worker upstart up",
      host_name           => $::fqdn,
    }
  }
}
