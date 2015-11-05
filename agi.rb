require "socket"
require "timeout"

class AGI
  def initialize
    @server = TCPServer.new(0)
  end

  def url
    "agi://localhost:#{@server.addr[1]}"    
  end

  def on_session
    socket = Timeout::timeout(30) { @server.accept }
    result = yield Session.new(socket)
    socket.close
    result
  end

  class Session
    attr_reader :headers

    def initialize(socket)
      @socket = socket
      @headers = {}
      read_headers
    end

    def answer
      @socket.puts "ANSWER"
      read_response
    end

    def stream_file(filename, escape_digits = '0123456789#*')
      @socket.puts %(STREAM FILE "#{filename}" "#{escape_digits}")
      read_response
    end

    def wait_for_digit(timeout = 3000)
      @socket.puts "WAIT FOR DIGIT #{timeout}"
      response = read_response
      case response
      when 0
        raise "timeout"
      when -1
        raise "failure"
      else
        response.chr
      end
    end

    def send_dtmf(digits)
      @socket.puts "EXEC SendDTMF #{digits}"
      read_response
    end

    private

    def read_response
      line = @socket.gets.strip
      if line == "HANGUP"
        raise "HANGUP"
      elsif line =~ /^(\d+)\s+result=(-?[^\s]*)(?:\s+\((.*)\))?(?:\s+endpos=(-?\d+))?/
        $2.to_i
      else
        raise "Could not parse result line: #{line}"
      end
    end


    def read_headers
      loop do
        line = @socket.gets.strip
        break if line.empty?
        if line =~ /(.+):\s*(.*)/
          @headers[$1] = $2
        else
          raise "AGI header line not understood: #{line}"
        end
      end
    end
  end
end