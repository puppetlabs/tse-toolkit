require 'json'
require 'puppet/provider/vagrant'

Puppet::Type.type(:vagrant_plugin).provide(:vagrant_plugin, :parent => Puppet::Provider::Vagrant) do
  def self.fetch_plugin_json(user_plugin_files)
    result = Hash.new

    user_plugin_files.each do |user, plugin|
      if File.exist? plugin
        json = JSON.parse IO.read(plugin)

        if json.has_key? "installed"
          result[user] = json["installed"]
        end
      end
    end

    result
  end

  def self.installed_plugins(user_plugin_json_files)
    @installed_plugins ||= fetch_plugin_json(user_plugin_json_files)
  end

  def create
    args = [
      "plugin",
      "install",
      @resource[:name]
    ]

    args << '--plugin-version' << @resource[:version] if @resource[:version] and resource[:version] != 'latest'

    vagrant(*args)
  end

  def destroy
    args = [
      "plugin",
      "uninstall",
      @resource[:name]
    ]

    vagrant(*args)
  end

  def exists?
    installed=self.class.installed_plugins(user_plugins_json_files)
    installed.member? @resource[:user] and installed[@resource[:user]].member? @resource[:name]
  end

  # We do not have access to model.catalog in self.class
  def user_plugins_json_files
    users = model.catalog.resources.
      find_all{|s| s.type==:vagrant_plugin}.
      collect{|s| s[:user]}

    users.uniq.inject(Hash.new) do |result, user|
      result[user] = "#{Etc.getpwnam(user).dir}/.vagrant.d/plugins.json"
      result
    end
  end
end
