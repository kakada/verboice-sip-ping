require 'yaml'

class Settings
  def self.config
    @@settings ||= YAML::load_file(File.expand_path('../config/settings.yml', __FILE__))
  end

  def self.asterisk_config
    config['asterisk']
  end

  def self.nuntium_config
    config['nuntium']
  end
end