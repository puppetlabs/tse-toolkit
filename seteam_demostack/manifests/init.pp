class seteam_demostack{
  class { seteam_demostack::env: } ->
  class { seteam_demostack::clean: } ->
  class { seteam_demostack::vbox: } ->
  class { seteam_demostack::vagrant: } 
}