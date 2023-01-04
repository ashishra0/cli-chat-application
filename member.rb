class Member

  attr_reader :username, :socket
  def initialize(username, socket)
    @username = username
    @socket = socket
  end

  def welcome_from(members)
    @socket.puts "Welcome, #{@username}! There are currently #{members.count} people online"
  end
end
