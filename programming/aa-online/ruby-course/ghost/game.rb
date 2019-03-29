class Game
  attr_reader :dictionary, :current_player, :previous_player

  def initialize(players, fragment)
    @players = players
    @fragment = fragment
    @dictionary = Hash.new(false)
    @current_player = @players[0]
    @previous_player = @players[1]
    File.open("./dictionary.txt").each do |word|
      @dictionary[word.chomp] = true
    end
  end

  def play_round
  end

  def next_player!
    @current_player, @previous_player = @previous_player, @current_player
  end

  def take_turn_player(player)
    guess = gets.chomp
    until valid_play?(guess)
      puts "Invalid play."
      guess = gets.chomp
    end
  end

  def valid_play?(guess)
    alphabet = ("a".."z").to_a
    
  end



end
