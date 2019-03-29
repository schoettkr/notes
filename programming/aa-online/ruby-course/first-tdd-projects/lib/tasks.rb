class Array
  def my_uniq
    uniques = []
    self.each { |val| uniques.push(val) unless uniques.include?(val) }
    uniques
  end

  def two_sum
    sum_positions = []
    self.each_with_index do |el1, idx1|
      self.each_with_index do |el2, idx2|
        if idx2 > idx1
          sum_positions << [idx1, idx2] if (el1 + el2 == 0)
        end
      end
    end
    sum_positions
  end
end

def my_transpose(matrix)
  consistent_dimensions = matrix.all? { |row| row.is_a?(Array) && row.length == matrix.length }
  raise "Not a square matrix" unless consistent_dimensions

  transposed_matrix = []
  matrix.each_with_index do |_, idx1|
    transposed_row = []
    matrix.each_with_index do |_, idx2|
      transposed_row << matrix[idx2][idx1]
    end
    transposed_matrix << transposed_row
  end

  transposed_matrix
end

def pick_stock(stock_prices)
  raise ArgumentError.new("stock_prices is not an array") unless stock_prices.is_a?(Array)

  max_profit = 0
  max_profit_pair = nil

  stock_prices.each_with_index do |buy_price, buy_idx|
    stock_prices.each_with_index do |sell_price, sell_idx|
      if sell_idx > buy_idx && sell_price - buy_price > max_profit
        max_profit = sell_price - buy_price
        max_profit_pair = [buy_idx, sell_idx]
      end
    end
  end

  max_profit_pair
end
