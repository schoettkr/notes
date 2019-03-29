class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @cups = []
    @player1 = name1
    @player2 = name2
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    (0..13).each do |i|
       if i != 6 && i != 13
         @cups[i] = Array.new(4, :stone)
       else
         @cups[i] = []
       end
    end
  end

  def valid_move?(start_pos)
    raise "Invalid starting cup" unless start_pos.between?(0,13)
    raise "Starting cup is empty" if @cups[start_pos].length == 0
    true
  end

  def make_move(start_pos, current_player_name)
    stones_to_distribute = @cups[start_pos].length
    @cups[start_pos] = []
    pos = start_pos + 1
    while stones_to_distribute > 0
      unless (current_player_name == @player1 && pos == 13) ||
             (current_player_name == @player2 && pos == 6)
        @cups[pos%14].push(:stone)
        stones_to_distribute -= 1
      end
      pos += 1
    end
    render
    next_turn((pos-1)%14)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    if (ending_cup_idx == 6  || @current_player == @player2)
      return :prompt
    end

    if @cups[ending_cup_idx].length > 1
      return ending_cup_idx
    end

    if @cups[ending_cup_idx].length == 1
      return :switch
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    p1_cups_empty = @cups[0..5].all? { |cup|  cup.length == 0 }
    p2_cups_empty = @cups[7..12].all? { |cup|  cup.length == 0 }
    return p1_cups_empty || p2_cups_empty
  end

  def winner
    case (@cups[6].length <=> @cups[13].length)
    when -1
      return @player2
    when 0
      return :draw
    when 1
      return @player1
    end

  end
end
