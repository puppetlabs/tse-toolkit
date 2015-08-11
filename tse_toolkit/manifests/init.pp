class tse_toolkit (
  $vbox_version     = $tse_toolkit::params::vbox_version,
  $vbox_patch_level = $tse_toolkit::params::vbox_patch_level,
  $vagrant_version  = $tse_toolkit::params::vagrant_version,
  $vagrant_plugins  = $tse_toolkit::params::vagrant_plugins,
  $user             = $tse_toolkit::params::user,
) inherits tse_toolkit::params {

  class { tse_toolkit::env: 
    user => $user,
  } ->
  class { tse_toolkit::clean: } ->
  class { tse_toolkit::vbox: 
    version     => $vbox_version,
    patch_level => $vbox_patch_level,

  } ->
  class { tse_toolkit::vagrant: 
    version => $vagrant_version,
    plugins => $vagrant_plugins,
    user    => $user,
  } 
}