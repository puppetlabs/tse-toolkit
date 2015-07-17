# seteam-demostack
Bootstrap TSE demo environment on (mostly) clean Mac OS X box. Ruby script (autodemo.rb) will pull
down necessary bits and packages to build base environment needed to bootstrap rest of TSE demo
stack (Puppet client binaries and requisite code).

Forked code from boxen project is included as Puppet types and providers but are not currently being
used.

## Installation
Run bootstrap_demostack.rb, and the script should take care of the rest.  You need to provide a user (-u|--username) or you'll just get instructions spit back :).  This will install latest Puppet
agent for OS X, then kick off a Puppet run to install other packages and plugins.

Current Install List
* puppet-agent 4.2.0
* VirtualBox 5.0 build 101573
* Vagrant 1.7.4
  * oscar
  * vagrant-multiprovider-snap
  * vagrant-reload

## Usage

Changes to versions, Vagrant plugins and other params should be done in provided params.pp which is located in
$modulesdir/seteam_demostack/manifests/params.pp

Usage: autodemo.rb -u|--username username

                   Note: default behavior is to install all-in-one agent if it isn't already
                   installed.  Also will leave older agent installs alone.  If you want to
                   update ONLY all-in-one agent, please choose '--update'.

    -u, --username USERNAME          username is mandatory.
        --update                     Update Puppet all-in-one agent. Leave older installs alone.
        --nuclear                    Completely wipe out earlier Puppet installs and install latest agent.
    -h, --help

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

Puppet code, types, and providers forked from following repos:
* https://github.com/boxen/puppet-virtualbox
* https://boxen.github.com://github.com/boxen/puppet-vagrant 
