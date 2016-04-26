class toolkit (
  $vbox_version     = $toolkit::params::vbox_version,
  $vbox_patch_level = $toolkit::params::vbox_patch_level,
  $vagrant_version  = $toolkit::params::vagrant_version,
  $vagrant_plugins  = $toolkit::params::vagrant_plugins,
  $user             = $toolkit::params::user,
  $pe_demo_url      = $toolkit::params::pe_demo_url, 
) inherits toolkit::params {

  class { toolkit::env: 
    user        => $user,
    pe_demo_url => $pe_demo_url,
  } ->
  class { toolkit::clean: } ->
  class { toolkit::vbox: 
    version     => $vbox_version,
    patch_level => $vbox_patch_level,

  } ->
  class { toolkit::vagrant: 
    version => $vagrant_version,
    plugins => $vagrant_plugins,
    user    => $user,
  } 
}