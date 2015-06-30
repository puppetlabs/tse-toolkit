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

  autorequire :file do
    %W(#{Etc.getpwnam(self[:user]).dir}/.vagrant.d/license-#{self[:name]}.lic)
  end
end
