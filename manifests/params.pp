class toolkit::params {
  $user             = 'username'
  $pe_version       = '2016.5.x'
  $pe_demo_url      = "http://tse-builds.s3-us-west-2.amazonaws.com/${pe_version}/releases/pe-demo-latest.tar.gz"
  $vbox_version     = '5.1.14'
  $vbox_patch_level = '112924'
  $vagrant_version  = '1.9.0'
  $vagrant_plugins  = [ 'oscar', 'vagrant-hosts', 'vagrant-multiprovider-snap', 'vagrant-reload', 'vagrant-cachier']
  $packages         = [ "Vagrant_${vagrant_version}", "VirtualBox-${vbox_version}-${vbox_patch_level}"]
}
