require "socket"

class AMI
  def initialize
    @socket = TCPSocket.new("localhost", 5038)
    @socket.gets # Ignore the Asterisk greeting message
  end

  def login(username, password)
    action("login", username: username, secret: password)
  end

  def originate(options = {})
    action("originate", options)
  end

  def action(action_name, options = {})
    @socket.puts "Action: #{action_name}"
    options.each do |name, value|
      @socket.puts "#{name}: #{value}"
    end
    @socket.puts

    wait_response
  end

  private 

  def wait_response
    loop do
      packet = read_packet
      if packet["Response"]
        if packet["Response"] == "Error"
          raise packet["Message"]
        else
          return packet
        end
      end
      # Ignore events
    end
  end

  def read_packet
    packet = {}

    loop do
      line = @socket.gets.strip
      break if line.empty?

      if line =~ /(.+): (.+)/
        packet[$1] = $2
      else
        raise "AMI response line not understood: #{line}"
      end
    end

    packet
  end

end