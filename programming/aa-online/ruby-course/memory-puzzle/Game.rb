require_relative "./Card.rb"
require_relative "./Board.rb"

class Game

  def initialize
    @board = Board.new
    @previous_guess = nil
  end

  def play
    while !@board.won?
      system("clear")
      @board.render
      puts "Please enter a position of a card you'd like to flip (e.g '2,3')"
      guess = gets.chomp.split(",")
      make_guess(guess)
    end
    puts "Finally! You won."
  end

  def make_guess(guess)
    if @previous_guess
      card1 = @previous_guess
      card2 = @board.reveal(guess)

      if !card2
        puts "Card is already revealed"
        return
      end

      system("clear")
      @board.render

      if card1 == card2
        puts "It's a match!"
      else
        puts "No match."
        card1.hide
        card2.hide

      end

      @previous_guess = nil
      sleep(2)
    else 
      @previous_guess = @board.reveal(guess)
    end
  end
end

g = Game.new
g.play
