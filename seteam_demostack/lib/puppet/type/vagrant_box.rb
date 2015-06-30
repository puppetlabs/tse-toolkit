Puppet::Type.newtype :vagrant_box do
  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    defaultto :present
  end

  newparam :name do
    isnamevar
  end

  newparam :source do
  end

  newparam :user do
    defaultto(Facter.value(:boxen_user) || 'root')
  end

  newparam :force do
    validate do |value|
      unless value.is_a? Boolean
        raise Puppet::Error, "Force must be true or false."
      end
    end
  end

  autorequire :package do
    catalog.resources.
      find_all{|s| s.type == :package and s[:name] =~ /^[Vv]agrant/ }.
      collect{|s| s[:name]}
  end

  autorequire :vagrant_plugin do
    Array.new.tap do |a|
      case vprovider = self[:name].partition('/').last
      when 'virtualbox'
        # built in
      when 'vmware_fusion'
        a << 'vagrant-vmware-fusion'
      else
        a << vprovider unless vprovider.nil?
      end
    end
  end
end
