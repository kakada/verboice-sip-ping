require "./ami.rb"
require "./agi.rb"
require "./call_tester.rb"

AMI_USERNAME = "verboice"
AMI_PASSWORD = "verboice"
SIP_CHANNEL = "verboice_39-outbound"

tester = CallTester.new(AMI_USERNAME, AMI_PASSWORD, SIP_CHANNEL)
tester.test("verboice.com", "17772892961")

exit(1) if tester.failed
