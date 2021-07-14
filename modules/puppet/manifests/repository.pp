# == Class: puppet::repository
#
# Setup the APT repo for Puppet packages.
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   Hostname to use for the APT mirror.
#   Defaults to undefined because `$use_mirror` can be disabled.
#
# [*apt_mirror_gpg_key_fingerprint*]
#   Fingerprint to use for the APT mirror.
#   Defaults to undefined because `$use_mirror` can be disabled.
#
# [*use_mirror*]
#   Whether to use our own mirror of the PuppetLabs repo. You may want to
#   temporarily disable this if you're bringing up a new production
#   environment.
#   Default: true
#
class puppet::repository(
  $use_mirror = true,
  $apt_mirror_hostname,
  $apt_mirror_gpg_key_fingerprint,
) {
  # This is installed by bootstrapping. `apt::source` takes its place.
  package { 'puppetlabs-release':
    ensure => purged,
  }

  validate_bool($use_mirror)
  if $use_mirror {
    apt::source { 'puppetlabs':
      location     => "http://${apt_mirror_hostname}/puppetlabs-${::lsbdistcodename}",
      release      => $::lsbdistcodename,
      architecture => $::architecture,
      key          => $apt_mirror_gpg_key_fingerprint,
    }
  } else {
    apt::source {'puppetlabs':
      location => 'http://apt.puppetlabs.com',
      release  => $::lsbdistcodename,
      repos    => 'main dependencies',
      key      => 'D6811ED3ADEEB8441AF5AA8F4528B6CD9E61EF26', # Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>
    }
  }
}
