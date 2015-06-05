class seteam_demobuild(
	$packages = $seteam_demobuild::params::packages
) inherits seteam_demobuild::params {

  include seteam_demobuild::install_vbox
  include seteam_demobuild::install_vagrant

}