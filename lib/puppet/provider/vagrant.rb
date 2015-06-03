require 'etc'
require 'puppet/util/execution'

class Puppet::Provider::Vagrant <  Puppet::Provider
  include Puppet::Util::Execution

  private
  def home_dir
    Etc.getpwnam(@resource[:user]).dir
  end

  def custom_environment
    {
      "HOME"         => home_dir,
      "VAGRANT_HOME" => "#{home_dir}/.vagrant.d",
    }
  end

  def opts
    {
      :combine            => true,
      :custom_environment => custom_environment,
      :failonfail         => true,
      :uid                => @resource[:user],
    }
  end

  def vagrant(*args)
    cmd = ["/usr/bin/vagrant"] + args
    execute cmd, opts
  end
end
