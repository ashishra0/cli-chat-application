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
        username = get_username(socket)
        member = Member.new(username, socket)
        member.welcome_from(members)
        members.add(member)
        members.broadcast("joined the chat", member)
        # socket.close

        begin
          loop do
            message = socket.readline
            members.broadcast(message, member)
          end
        rescue EOFError
          socket.close
          members.remove(member)
          members.broadcast("[Left]", member)
        end
      end
    end
  end

  private

  def get_username(socket)
    socket.print("What's your name?")
    socket.gets.chomp
  end
end
