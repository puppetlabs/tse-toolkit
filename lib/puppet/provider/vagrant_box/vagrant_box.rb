require 'puppet/provider/vagrant'

Puppet::Type.type(:vagrant_box).provide(:vagrant_box, :parent => Puppet::Provider::Vagrant) do

  def create
    name, vprovider = @resource[:name].split('/')

    args = [
      "box",
      "add",
      name,
      @resource[:source],
      "--provider",
      vprovider
    ]

    args << "--force" if @resource[:force]

    vagrant(*args)
  end

  def destroy
    name, vprovider = @resource[:name].split('/')
    vagrant "box", "remove", name, "--provider", vprovider
  end

  def exists?
    if @resource[:force]
      false
    else
      name, vprovider = @resource[:name].split('/')

      boxes = vagrant "box", "list"
      boxes =~ /^#{name}\s+\(#{vprovider}(, .+)?\)/
    end
  end
end
