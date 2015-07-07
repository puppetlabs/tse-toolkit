# Public: Installs a vagrant plugin, with license support.
# forked from github:boxen/puppet-virtualbox
# Usage:
#
#   seteam_demostack::plugin { 'vmware-fusion': license => 'puppet:///some/license' }
#
#   seteam_demostack::plugin { 'boxen': ensure => absent }

define seteam_demostack::vagrant_plugin(
  $ensure  = 'present',
  $force   = false,
  $license = undef,
  $version = latest,
  $prefix  = true,
  $user    = $seteam_demostack::params::user
) {
  include seteam_demostack::params
  $plugin_name = $name

  if $license {
    file { "/Users/${user}/.vagrant.d/license-${plugin_name}.lic":
      ensure  => $ensure,
      mode    => '0644',
      source  => $license,
      replace => $force,
    }
  }

  vagrant_plugin { $plugin_name:
    ensure  => $ensure,
    version => $version,
    user    => $user,
  }
}
