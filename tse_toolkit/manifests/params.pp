class tse_toolkit::params {

  $user           = 'username'
  $pe_version     = '2015.3.x'
  $pe_demo_url    = "http://tse-builds.s3-us-west-2.amazonaws.com/${pe_version}/releases/pe-demo-latest.tar.gz"

  $vbox_version     = '5.0.12'
  $vbox_patch_level = '104815'

  $vagrant_version = '1.7.4'
  $vagrant_plugins = [ 'oscar', 'vagrant-hosts', 'vagrant-multiprovider-snap', 'vagrant-reload']

  $packages = [ "Vagrant_${vagrant_version}",
  "VirtualBox-${vbox_version}-${vbox_patch_level}"]
}
