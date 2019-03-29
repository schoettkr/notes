require_relative 'tic_tac_toe_node'
require "byebug"

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    node = TicTacToeNode.new(game.board, mark)
    # debugger
    node.children.each do |childNode|
      return childNode.prev_move_pos if childNode.winning_node?(mark)
    end
    node.children.each do |childNode|
      return childNode.prev_move_pos unless childNode.losing_node?(mark)
    end

    raise "Error: This should not have happened."
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
