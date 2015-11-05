class CallTester
  attr_reader :failed, :error_message

  def initialize(ami_username, ami_password, sip_channel)
    @agi = AGI.new
    @ami = AMI.new
    @sip_channel = sip_channel

    @ami.login ami_username, ami_password
    @failed = false
    @error_message = nil
  end

  def test(server_name, number)
    @ami.originate channel: "SIP/#{@sip_channel}/#{number}",
                   application: "AGI",
                   data: @agi.url,
                   async: true

    output = @agi.on_session do |session|
      session.answer
      session.send_dtmf "0"
      12.times.map do
        session.wait_for_digit 10000
      end.join
    end

    if output != '0123456789#*'
      raise "Invalid response from server: #{output}"
    end
  rescue Exception => ex
    @error_message = "ERROR with server #{server_name}: #{ex.message}"
    STDERR.puts @error_message
    @failed = true
  end
end