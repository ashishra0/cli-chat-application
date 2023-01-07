class Members
  include Enumerable

  def initialize
    @members = []
  end

  def each
    @members.each { |member| yield member }
  end

  def add(member)
    @members << member
  end
  
  def remove(member)
    @members.delete(member)
  end

  def broadcast(message, sender)
    receivers = @members - [sender]
    receivers.each do |receiver|
      receiver.socket.puts("> #{sender.username}: #{message}")
    end
  end

  def register(socket)
    username = get_username(socket)
    member = Member.new(username, socket)
    member.welcome_from(self)
    add(member)
    broadcast("[Joined]", member)

    member
  end

  def disconnect(member)
    member.socket.close
    remove(member)
    broadcast("[Left]", member)
  end

  def start_listening_to(member)
    loop do
      message = member.socket.readline
      broadcast(message, member)
    end
  end

  private

  def get_username(socket)
    socket.print("What's your name?")
    socket.gets.chomp
  end
end
