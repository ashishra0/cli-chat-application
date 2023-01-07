require 'socket'
require './members'
require './member'

class ChatServer

  attr_reader :tcp_server, :startup_message, :members

  def initialize
    @tcp_server = TCPServer.new(2000)
    @startup_message = "Server running on port 2000"
    @members = Members.new
  end

  def start_server
    while true
      tcp_socket = tcp_server.accept
      Thread.new(tcp_socket) do |socket|
        startup_message
        member = members.register(socket)
        begin
          members.start_listening_to(member)
        rescue EOFError
          members.disconnect(member)
        end
      end
    end
  end
end
