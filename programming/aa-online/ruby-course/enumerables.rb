class Array
  def my_each(&prc)
    i = 0
    while i < self.length
      prc.call(self[i])
      i += 1
    end
    self
  end

  def my_select(&prc)
    new_arr = []
    self.my_each do |element|
      new_arr << element if prc.call(element)
    end
    new_arr
  end

  def my_reject(&prc)
    self.my_select do |element|
      !prc.call(element)
    end
  end

  def my_any?(&prc)
    self.my_each do |element|
      return true if prc.call(element)
    end
    false
  end

  def my_all?(&prc)
    self.my_each do |element|
      return false if !prc.call(element)
    end
    true
  end

  def my_flatten
    flattened = []
    self.my_each do |element|
      if element.kind_of?(Array)
        flattened += element.my_flatten
      else
        flattened << element
      end
    end
    flattened
  end

  def my_zip(*args)
    result_arr = []
    sub_array_length = args.length + 1
    i = 0
    while i < self.length do
      subarr = Array.new(sub_array_length, nil)
      k = 0
      while k < sub_array_length do
        if k != 0
          subarr[k] = args[k-1][i]
        else
          subarr[k] = self[k+i]
        end
        k += 1
      end
      result_arr << subarr
      i += 1
    end
    result_arr
  end

  def my_rotate(rotations = 0)
    if rotations < 0
      (rotations*-1).times { self.unshift(self.pop) }
    elsif rotations > 0
      rotations.times { self.push(self.shift)}
    else
      self.push(self.shift)
    end
    self
  end

  def my_join(sep = "")
    res_string = ""
    self.each_with_index do |el, idx|
      res_string += el
      res_string += sep if idx < self.length - 1
    end
    res_string
  end

  def my_reverse
    reversed = []
    self.my_each do |el|
      reversed.unshift(el)
    end
    reversed
  end
end

# a = [1, 2, 3]
# return_value = [1, 2, 3].my_each do |num|
#   puts num
# end.my_each do |num|
#   puts num
# end

# p return_value

# p a.my_select { |num| num > 1 } # => [2, 3]
# p a.my_select { |num| num == 4 } # => []

# p a.my_reject { |num| num > 1 } # => [1]
# p a.my_reject { |num| num == 4 } # => [1, 2, 3]

# p a.my_any? { |num| num > 1 } # => true
# p a.my_any? { |num| num == 4 } # => false
# p a.my_all? { |num| num > 1 } # => false
# p a.my_all? { |num| num < 4 } # => true

# p [1, 2, 3, [4, [5, 6]], [[[7]], 8]].my_flatten

# a = [ 4, 5, 6 ]
# b = [ 7, 8, 9 ]
# p [1, 2, 3].my_zip(a, b) # => [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
# p a.my_zip([1,2], [8])   # => [[4, 1, 8], [5, 2, nil], [6, nil, nil]]
# p [1, 2].my_zip(a, b)    # => [[1, 4, 7], [2, 5, 8]]

# c = [10, 11, 12]
# d = [13, 14, 15]
# p [1, 2].my_zip(a, b, c, d)    # => [[1, 4, 7, 10, 13], [2, 5, 8, 11, 14]]

# a = [ "a", "b", "c", "d" ]
# p a.my_rotate         #=> ["b", "c", "d", "a"]
# a = [ "a", "b", "c", "d" ]
# p a.my_rotate(2)      #=> ["c", "d", "a", "b"]
# a = [ "a", "b", "c", "d" ]
# p a.my_rotate(-3)     #=> ["b", "c", "d", "a"]
# a = [ "a", "b", "c", "d" ]
# p a.my_rotate(15)     #=> ["d", "a", "b", "c"]

# a = [ "a", "b", "c", "d" ]
# p a.my_join         # => "abcd"
# p a.my_join("$")    # => "a$b$c$d"

p [ "a", "b", "c" ].my_reverse   #=> ["c", "b", "a"]
p [ 1 ].my_reverse               #=> [1]
