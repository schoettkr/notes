require_relative "./piece"

BOARD_SIZE = 8 

class Board
  def initialize
    @rows = []
    BOARD_SIZE.times do
      if @rows.length < 2 || @rows.length >= 6
        @rows.push(Array.new(8) { Piece.new })
      else
        @rows.push(Array.new(8, nil))
      end
    end
    @rows
  end

  def move_piece(start_pos, end_pos)
    unless self[start_pos].is_a?(Piece)
      raise ArgumentError.new("There is no piece at the provided start_pos")
    end
    if (self[end_pos].is_a?(Piece) ||
        !end_pos[0].between?(0, 7) ||
        !end_pos[1].between?(0, 7))
      raise ArgumentError.new("Cannot move piece to the provided end_pos")
    end
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
  end

  def [](pos)
    row, col = pos
    target_row = @rows[row]
    target_row[col] if target_row
  end

  def []=(pos, val)
    row, col = pos
    target_row = @rows[row]
    target_row[col] = val if target_row
  end
end
