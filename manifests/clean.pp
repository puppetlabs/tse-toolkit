# On OS X, Puppet leaves behind a file to 'know' it installed something, this cleans
# it up, before determining whether or not to install.
class toolkit::clean {
  exec { 'clean-vagrant-install':
    command => "/bin/rm /var/db/.puppet_pkgdmg_installed_Vagrant*",
    onlyif  => [
                "/bin/test -f /var/db/.puppet_pkgdmg_installed_Vagrant.*",
                "/bin/test ! -f /usr/local/bin/vagrant"
               ],
  } 
  exec { 'clean-vbox-install':
    command => "/bin/rm /private/var/db/.puppet_pkgdmg_installed_VirtualBox*",
    onlyif  => [
                "/bin/test -f /private/var/db/.puppet_pkgdmg_installed_VirtualBox.*",
                "/bin/test ! -d /Applications/VirtualBox.app/"
               ],
  }
}
