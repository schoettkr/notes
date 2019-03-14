# Monkey-Patch Ruby's existing Array class to add your own custom methods
class Array
  def span
    return nil if self.empty?
    self.max - self.min
  end

  def average
    return nil if self.empty?
    self.sum / self.length.to_f
  end

  def median
    return nil if self.empty?
    sorted = self.sort

    return sorted[(sorted.length)/2] if sorted.length.odd?

    (sorted[(sorted.length-1)/2] + sorted[(sorted.length)/2])/2.0
  end

  def counts
    counts = Hash.new(0)
    self.each { |n| counts[n] += 1 }
    counts
  end
  
  def my_count(val)
    self.counts[val]
  end

  def my_index(val)
    self.each_with_index { |el, i| return i if el == val}
    nil
  end

  def my_uniq
    uniques = {}
    self.each { |el| uniques[el] = true}
    uniques.keys
  end

  def my_transpose
    len = self.length
    transposed = Array.new(len) { Array.new(len) }
    (0...len).each do |row|
      (0...len).each do |col|
        transposed[row][col] = self[col][row]
      end
    end
    transposed
  end
end

