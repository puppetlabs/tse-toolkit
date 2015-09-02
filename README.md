# seteam-demostack
Bootstrap TSE demo environment on a Mac OSX box. Ruby script (install.rb) will pull
down necessary bits and packages to build base environment needed to bootstrap rest of TSE demo
stack (Puppet client binaries and requisite code).

Forked code from boxen project is included as Puppet types and providers but are not currently being
used.  This will likely be removed from future versions.

## Installation/Usage
Run this:

```
curl -sL http://git.io/vGDYa | sudo ruby
```
That will install latest stable release of the demostack to your local user account.  Command options are
detailed below.

## Detailed Usage

If you're running VirtualBox currently, power off your VMs first before running this.  It's best if you 
remove old versions of VirtualBox as well since package management on OS X is a little lacking and 
Puppet wouldn't "know" about previous installs.  Same goes for Vagrant.  Both apps come with uninstall 
scripts that you'll want to run.  Note, this repo contains a script located at tools/clean.sh 
that will basically undo everything install.rb does.  Please be careful with this as there is an option 
to remove a user account and not much error checking.  The script will call the Vagrant and VirtualBox 
uninstall scripts as a part of its process.

Changes to versions, Vagrant plugins and other params should be done in provided params.pp which is located in
$modulesdir/tse_toolkit/manifests/params.pp

```
Usage: install.rb -u|--username username

                   Note: default behavior is to install all-in-one agent if it isn't already
                   installed.  Also will leave older agent installs alone.  If you want to
                   update ONLY all-in-one agent, please choose '--update'.

    -u, --username USERNAME          Install for a specified username.
        --update                     Update Puppet all-in-one agent. Leave older installs alone.
        --nuclear                    Completely wipe out earlier Puppet installs and install latest agent.
    -h, --help
```

You need superuser privileges for it to work or the script will bail.  If you don't have Puppet-agent 
already installed, it will do that for you, otherwise, it'll leave whatever version you're currently 
kjjrunning alone.  You can force an uninstall and update to most recent version 
with ```--update``` switch.  ```--nuclear``` forcibly removes ALL previous versions of Puppet, Hiera, Facter, 
and Puppet-agent before installing the most recent Puppet-agent.

Current Install List
* puppet-agent 4.2.0
* VirtualBox 5.0 build 101573
* Vagrant 1.7.4
  * oscar
  * vagrant-multiprovider-snap
  * vagrant-reload
  * vagrant-hosts

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
