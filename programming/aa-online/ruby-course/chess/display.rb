require "colorize"
require_relative "./board"

class Display
  def initialize(board)
    @board = board
  end

  def render
    p @board
  end
end

b = Board.new

d = Display.new(b)

d.render
