require_relative "room"

class Hotel
  def initialize(name, rooms)
    @name = name
    @rooms = {}
    rooms.each do |k, v|
      @rooms[k] = Room.new(v)
    end
  end

  def name
    @name.split.map(&:capitalize).join(" ")
  end

  def rooms
    @rooms
  end

  def room_exists?(name)
    @rooms.has_key?(name)
  end

  def check_in(person_name, room_name)
    if room_exists?(room_name)
      if @rooms[room_name].add_occupant(name)
        puts "check in successfull"
      else
        puts "sorry, room is full"
      end
    else
      puts "sorry, room does not exist"
    end
  end

  def has_vacancy?
    !@rooms.values.all?(&:full?)
  end

  def list_rooms
    @rooms.each do |name, room|
      puts "#{name}: available spaces = #{room.available_space}"
    end
  end
      
end
