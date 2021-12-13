# == Class: Govuk_Node::S_transition_db_admin
#
# This machine class is used to administer Transition PostgreSQL RDS instances.
#
# === Parameters
#
class govuk::node::s_transition_db_admin inherits govuk::node::s_postgresql_db_admin_base {
  # include all PostgreSQL classes that create databases and users
  class { '::govuk::apps::transition::postgresql_db': } ->

  # Include the Bouncer PostgreSQL Role class for its database permissions
  class { '::govuk::apps::bouncer::postgresql_role': }

  $postgres_backup_desc = 'RDS Transition PostgreSQL backup to S3'
}
