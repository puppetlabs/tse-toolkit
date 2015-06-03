# Public: Installs a vagrant plugin, with license support.
#
# Usage:
#
#   vagrant::plugin { 'vmware-fusion': license => 'puppet:///some/license' }
#
#   vagrant::plugin { 'boxen': ensure => absent }

define seteam-autodemo::vagrant-plugin(
  $ensure  = 'present',
  $force   = false,
  $license = undef,
  $version = latest,
  $prefix  = true
) {
  # require seteam-autodemo::install-vagrant

  if !$prefix or $name =~ /^vagrant-/ {
    $plugin_name = $name
  } else {
    $plugin_name = "vagrant-${name}"
  }

  if $license {
    file { "/Users/${::boxen_user}/.vagrant.d/license-${plugin_name}.lic":
      ensure  => $ensure,
      mode    => '0644',
      source  => $license,
      replace => $force
    }
  }

  vagrant_plugin { $plugin_name:
    ensure  => $ensure,
    version => $version
  }
}
