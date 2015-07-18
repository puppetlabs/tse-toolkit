# Public: Installs a vagrant plugin, with license support.
# forked from github:boxen/puppet-virtualbox
# Usage:
#
#   seteam_demostack::plugin { 'vmware-fusion': license => 'puppet:///some/license' }
#
#   seteam_demostack::plugin { 'boxen': ensure => absent }

define seteam_demostack::vagrant_plugin(
  $license = undef,
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

  exec { "vagrant_plugin_${name}":
    command => "/usr/bin/su - ${user} -c '/usr/local/bin/vagrant plugin install ${name}'",
    unless  => "/usr/bin/su - ${user} -c '/usr/local/bin/vagrant plugin list | grep ${name}'",
  }
}
