# Public: Installs a vagrant plugin, with license support.
# forked from github:boxen/puppet-virtualbox
# Usage:
#
#   seteam_demobuild::plugin { 'vmware-fusion': license => 'puppet:///some/license' }
#
#   seteam_demobuild::plugin { 'boxen': ensure => absent }

define seteam_demobuild::vagrant_plugin(
  $ensure  = 'present',
  $force   = false,
  $license = undef,
  $version = latest,
  $prefix  = true,
  $user    = $seteam_demobuild::params::user
) {
  include seteam_demobuild::params
  $plugin_name = $name

  if $license {
    file { "/Users/${::boxen_user}/.vagrant.d/license-${plugin_name}.lic":
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
