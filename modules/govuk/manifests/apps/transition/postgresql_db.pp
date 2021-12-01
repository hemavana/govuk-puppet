# == Class: govuk::apps::transition::postgresql_db
#
# === Parameters
#
# [*password*]
#   The DB instance password.
#
class govuk::apps::transition::postgresql_db (
  $password = '',
  $host = undef,
  $admin_username = undef,
  $admin_password = undef,
) {
  $connect_settings = {
    'PGUSER'     => $admin_username,
    'PGPASSWORD' => $admin_password,
    'PGHOST'     => $host,
  }

  govuk_postgresql::db { 'transition_production':
    user              => 'transition',
    password          => $password,
    rds               => true,
    connect_settings  => $connect_settings,
    rds_root_user     => $admin_username,
  }
}
