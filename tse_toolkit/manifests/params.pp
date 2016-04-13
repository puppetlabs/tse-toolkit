class tse_toolkit::params {

  $user           = 'username'
  $pe_version     = '2016.1.x'
  $pe_demo_url    = "http://tse-builds.s3-us-west-2.amazonaws.com/${pe_version}/releases/pe-demo-latest.tar.gz"

  $vbox_version     = '5.0.16'
  $vbox_patch_level = '105871'

  $vagrant_version = '1.8.1' 
  $vagrant_plugins = [ 'oscar', 'vagrant-hosts', 'vagrant-multiprovider-snap', 'vagrant-reload', 'vagrant-cachier']

  $packages = [ "Vagrant_${vagrant_version}",
  "VirtualBox-${vbox_version}-${vbox_patch_level}"]
}
