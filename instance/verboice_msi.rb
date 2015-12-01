require "../ami.rb"
require "../agi.rb"
require "../call_tester.rb"
require "../settings.rb"

tester = CallTester.new(Settings.asterisk_config['ami_username'], Settings.asterisk_config['ami_password'], Settings.asterisk_config['sip_channel'])
tester.test("MSI-110.74.193.186", "17772092786")

exit(1) if tester.failed
