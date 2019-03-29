require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    # base case
    if @board.over?
      return @board.won? && @board.winner != evaluator
    end

    if evaluator == @next_mover_mark
      return self.children.all? { |child| child.losing_node?(evaluator)}
    else
      return self.children.any? { |child| child.losing_node?(evaluator)}
    end
  end

  def winning_node?(evaluator)
    if @board.over?
      return @board.winner == evaluator
    end

    if evaluator == @next_mover_mark
      return self.children.any? { |child| child.winning_node?(evaluator) }
    else
      return self.children.all? { |child| child.winning_node?(evaluator) }
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    children = []
    @board.rows.each_with_index do |row, row_index|
      row.each_with_index do |pos, col_index|
        if @board.empty?([row_index, col_index])
          duped_board = @board.dup
          duped_board[[row_index, col_index]] = @next_mover_mark
          childMark = @next_mover_mark == :x ? :o : :x
          child = TicTacToeNode.new(duped_board, childMark, [row_index, col_index])
          children << child
        end
      end
    end
    children
  end
end

lel = TicTacToeNode.new(Board.new, :x)
lel.losing_node?(:x)
