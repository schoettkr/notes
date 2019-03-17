require_relative "board"
require_relative "player"

class Battleship
  attr_reader :board, :player, :remaining_misses

  def initialize(length)
    @player = Player.new
    @board = Board.new(length)
    @remaining_misses = @board.size/2
  end

  def start_game
    @board.place_random_ships
    puts "There are #{@board.num_ships} ships"
    @board.print
  end

  def lose?
    if @remaining_misses <= 0
      puts "You lose"
      return true
    end
    false
  end

  def win?
    if @board.num_ships == 0
      puts "You win"
      return true
    end
    false
  end

  def game_over?
    if self.win? || self.lose?
      return true
    end
    false
  end

  def turn
    success = @board.attack(@player.get_move)
    if !success
      @remaining_misses -= 1
    end
    puts "#{@remaining_misses} remaining."
    @board.print
  end

end
