# tse-toolkit
Bootstrap TSE demo environment on a Mac OSX box. Ruby script (install.rb) will pull
down latest Puppet All-In-One (AIO) agent or update you, then install tse/nimbus and a base 
config file (nimbus-user.conf) where it'll hand-off the installation and configuration of additonal
components.

## Installation/Usage
Run this:

```
curl -sL http://git.io/tse-toolkit | sudo ruby
```

## Detailed Usage

If you're running VirtualBox currently, power off your VMs first before running this.  It's best if you 
remove old versions of VirtualBox as well since package management on OSX is a little lacking and 
Puppet wouldn't "know" about previous installs.  Same goes for Vagrant.  Both apps come with uninstall 
scripts that you'll want to run.  

Note, this repo contains a script located at tools/clean.sh that will basically undo everything install.rb + 
Nimbus/Puppet does.

You need superuser privileges for it to work or the script will bail.  If you don't have Puppet-agent 
already installed or you're on an older version, it'll install the latest for you.  Your agent install will
be left alone if you're already on the latest.  Either way, anything in /etc/puppetlabs will be left alone.

Check nimbus-base.conf to see list of modules, packages, and plugins that will get installed as a part of
this process.

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
