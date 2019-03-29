require_relative "./Card.rb"

class Board

  def initialize
    self.populate
  end

  def populate
    possible_values = ("A".."Z").to_a
    @grid = Array.new(4) { Array.new(4, nil) }

    fields = field_count
    random_pairs = possible_values.sample(fields / 2)
    placed_cards = 0
    
    while placed_cards < fields
      card = random_pairs.pop
      place_card(card)
      placed_cards += 1
      place_card(card)
      placed_cards += 1
    end
  end

  def render
    puts "  0 1 2 3"
    @grid.each_with_index do |row, row_index|
      values = [row_index]
      row.each do |val|
        if val.display
          values << val.display
        else
          values << " "
        end
      end
      puts values.join(" ")
    end
  end

  def won?
    @grid.flatten.all? { |card| card.showing? }
  end

  def reveal(guessed_pos)
    card = @grid[guessed_pos[0].to_i][guessed_pos[1].to_i]
    unless (card.showing?)
      card.reveal
      card.display
      return card
    end
    nil
  end

  def place_card(card)
    coordinates = find_random_free_field 
    @grid[coordinates[0]][coordinates[1]] = Card.new(card)
  end

  def find_random_free_field
    coordinates = nil
    loop do
      coordinates = random_field_coordinates
      field = @grid[coordinates[0]][coordinates[1]]

      break if field == nil
    end
    coordinates
  end

  def random_field_coordinates
    width = @grid.length
    index = rand(self.field_count) # gets random index for grid as if it was 1D
    row = (index) / width
    col = index % width
    [row, col]
  end

  def field_count
    @grid.flatten.length
  end
    
end


c = Board.new
c.render
