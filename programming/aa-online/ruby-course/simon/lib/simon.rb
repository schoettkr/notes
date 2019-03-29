class Simon
  COLORS = %w(red blue green yellow)

  attr_accessor :sequence_length, :game_over, :seq

  def initialize
    @sequence_length = 1
    @seq = []
    @game_over = false
  end

  def play
    puts "The game starts now!"
    until @game_over
      take_turn
    end
    game_over_message
    reset_game
  end

  def take_turn
    puts show_sequence
    sleep(2)
    system("clear")
    require_sequence
    unless @game_over
      @sequence_length += 1
      round_success_message
    end
  end

  def show_sequence
    add_random_color
    @seq.join(", ")
  end

  def require_sequence
    puts "Repeat the sequence"
    input = gets.chomp.split(", ")
    @game_over = true if input != @seq
  end

  def add_random_color
    @seq.push(COLORS.sample)
  end

  def round_success_message
    puts "You succeeded in this round"
  end

  def game_over_message
    puts "The game is over you lost"
  end

  def reset_game
    @sequence_length = 1
    @seq = []
    @game_over = false
  end
end

game = Simon.new
game.play
