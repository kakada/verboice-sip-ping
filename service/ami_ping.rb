require "../ami.rb"
require "../settings.rb"

begin
  ami = AMI.new
  ami.login(Settings.asterisk_config['ami_username'], Settings.asterisk_config['ami_password'])
rescue
  STDERR.puts "ERROR: can't connect to Asterisk AMI on #{Settings.asterisk_config['server_name']}"
  exit(1)
end
