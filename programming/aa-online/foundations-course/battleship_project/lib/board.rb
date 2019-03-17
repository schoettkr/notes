class Board
  attr_reader :size

  def self.print_grid(array)
    array.each do |row|
      puts row.join(" ")
    end
  end

  def initialize(size)
    @size = size*size
    @grid = Array.new(size) { Array.new(size, :N) }
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, val)
    @grid[pos[0]][pos[1]] = val
  end

  def num_ships
    ships = 0
    @grid.each do |row|
      ships += row.count(:S)
    end
    ships
  end

  def attack(pos)
    if self[pos] == :S
      self[pos] = :H
      puts "you sunk my battleship!"
      return true
    else
      self[pos] = :X
      return false
    end
  end

  def random_position
    [rand(@grid.length), rand(@grid.length)]
  end

  def place_random_ships
    ships_to_place = @size/4.0
    while ships_to_place > 0
      pos = random_position
      ships_to_place -= 1 if self[pos] != :S
      self[pos] = :S
    end
  end

  def hidden_ships_grid
    @grid.map do |row|
      row.map do |cell|
        if cell == :S
          :N 
        else
          cell
        end
      end
    end
  end
 
  def cheat
    Board.print_grid(@grid)
  end

  def print
    Board.print_grid(hidden_ships_grid)
  end
end
