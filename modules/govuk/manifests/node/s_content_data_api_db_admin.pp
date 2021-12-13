# == Class: govuk_node::s_content_data_api_db_admin
#
# This machine class is used to administer the Content Data API
# PostgreSQL RDS instances.
#
class govuk::node::s_content_data_api_db_admin inherits govuk::node::s_postgresql_db_admin_base {
  # include all PostgreSQL classes that create databases and users
  class { '::govuk::apps::content_data_api::db': }
}
