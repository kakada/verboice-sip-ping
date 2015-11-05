require "./ami.rb"
require "./agi.rb"

AMI_USERNAME = "verboice"
AMI_PASSWORD = "verboice"
SIP_CHANNEL = "verboice_39-outbound"

tester = CallTester.new(AMI_USERNAME, AMI_PASSWORD, SIP_CHANNEL)
tester.test("verboice.com", "17772892962")

exit(1) if tester.failed
