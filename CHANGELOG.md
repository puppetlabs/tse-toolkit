# Change Log

## 1.2.0 (2016-04-25)

Updates:

 - Shift to use tse/nimbus as main configuration manager for Puppet.
 - Removed install options.  Defaults to updating to latest Puppet AIO or skipping if already on latest.
 - Cleaned up spaghetti code.


## 1.0.0 (2016-01-16)

Updates:

  - Update to VirtualBox version: 5.0.12
  - Additional Vagrant plugin: vagrant-cachier

Improvements:

  - Installs relevant VirtualBox Extensions.
  - Updates to Ruby script to download correct Puppet PC1 package depending OSX version.
  - Updates to PC1 URL reference in light of directory location changes by release team.
