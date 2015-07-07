require 'etc'

Puppet::Type.newtype(:vagrant_plugin) do
  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    aliasvalue :installed, :present
    aliasvalue :uninstalled, :absent

    defaultto :present
  end

  newparam :name do
    isnamevar
  end

  newparam :user do
    defaultto(Facter.value(:boxen_user) || 'root')
  end

  newparam :version

  autorequire :package do
    catalog.resources.
      find_all{|s| s.type == :package and s[:name] =~ /^[Vv]agrant/ }.
      collect{|s| s[:name]}
  end
  
  # Modify to original boxen code here to prevent custom type from just outright
  # failing if user homedir doesn't exist.  This allows creation of user account in same
  # manifest.
  #autorequire :file do
  #  %W(#{Etc.getpwnam(self[:user]).dir}/.vagrant.d/license-#{self[:name]}.lic)
  #end
  autorequire :file do
    begin
      %W(#{Etc.getpwnam(self[:user]).dir}/.vagrant.d/license-#{self[:name]}.lic)
    rescue
      puts "Homedir for :user doesn't exist, will try continuing..."
    end
  end
end
