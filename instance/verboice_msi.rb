require "../ami.rb"
require "../agi.rb"
require "../call_tester.rb"
require "../settings.rb"

require "nuntium"

tester = CallTester.new(Settings.asterisk_config['ami_username'], Settings.asterisk_config['ami_password'], Settings.asterisk_config['sip_channel'])
tester.test("MSI-110.74.193.186", "17772092786")

if tester.failed
  nuntium = Nuntium.new Settings.nuntium_config['host'], Settings.nuntium_config['account'], Settings.nuntium_config['application'], Settings.nuntium_config['password']
  nuntium.send_ao({
    to: "sms://#{Settings.config['notify_number']}",
    body: tester.error_message,
    suggested_channel: 'smart'
  })
  exit(1)
end
