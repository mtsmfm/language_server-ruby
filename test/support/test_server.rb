class TestServer
  attr_reader :stdin, :stdout, :stderr, :thread, :port

  def initialize(port = 12345)
    @stdin, @stdout, @stderr = Open3.popen3("bin/language_server-ruby")
    @port = port
    @thread = start_thread
    @thread.abort_on_exception = true
  end

  private

    def start_thread
      Thread.new do
        socket = TCPServer.open(port).accept

        socket_buffer = ""
        stdout_buffer = ""

        loop do
          readable_ios, writable_ios = IO.select([socket, stdout], [socket, stdin])

          readable_ios.each do |io|
            c = io.readchar

            case io
            when socket
              socket_buffer += c
            when stdout
              stdout_buffer += c
            end
          end

          next if readable_ios.any?

          writable_ios.each do |io|
            case io
            when stdin
              io.write(socket_buffer)
              socket_buffer.clear
            when socket
              io.write(stdout_buffer)
              stdout_buffer.clear
            end
          end
        end
      end
    end
end
