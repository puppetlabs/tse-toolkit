# seteam-demostack
Bootstrap TSE demo environment on (mostly) clean Mac OS X box. Ruby script (autodemo.rb) will pull
down necessary bits and packages to build base environment needed to bootstrap rest of TSE demo
stack (Puppet client binaries and requisite code).

## Installation
Run autodemo.rb, and the script should take care of the rest.  This will install latest Puppet
agent for OS X, then kick off a Puppet run to install other packages and plugins.

Current Install List
* VirtualBox
* Vagrant
  * oscar
  * vagrant-multiprovider-snap
  * vagrant-reload

## Usage

TODO: Write usage instructions

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

## Credits

TODO: Write credits

## License

TODO: Write license
