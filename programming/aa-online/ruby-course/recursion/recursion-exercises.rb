require "byebug"
def range(start, stop)
  return [] if stop < start
  range = [start]
  range += range(start+1, stop)
end
# p range(1, 5)

def sum_recursive(arr)
  return 0 if arr.length == 0
  sum = 0
  sum += arr.first + sum_recursive(arr[1..-1])
end

def sum_itertive(arr)
  sum = 0
  arr.each { |num| sum += num }
  sum
end

# p sum_recursive([1,2,3,4])
# p sum_itertive([1,2,3,4])


def exp1(b, n)
  return 1 if n == 0

  b * exp1(2, n-1)
end

# p exp1(2,8)

def exp2(b, n)
  return 1 if n == 0
  return b if n == 1

  if (n % 2 == 0)
    exp_to_half_base = exp2(b, n/2) 
    exp_to_half_base * exp_to_half_base
  else
    exp_to_next_even_half_base = exp2(b, (n-1)/2) 
    b * (exp_to_next_even_half_base * exp_to_next_even_half_base)
  end
end

# p exp2(2,8)

class Array
  def deep_dup
    res = []
    self.each do |el|
      if el.is_a? Array
        res << el.deep_dup
      else
        res << el
      end
    end
    res
  end
end

# robot_parts = [
#   ["nuts", "bolts", "washers"],
#   ["capacitors", "resistors", "inductors"]
# ]
# copy = robot_parts.deep_dup
# copy[1] << "LEDs"
# p robot_parts[1]
# p copy[1]

def fibs_rec(n)
  if n <= 2
    [0, 1].take(n)
  else
    fibs = fibs_rec(n-1)
    fibs << fibs[-2] + fibs[-1]
  end
end


def bsearch(array, target)
  return nil if array.length == 0
  middle_index = array.length / 2
  middle_element = array[middle_index]

  if middle_element < target
    middle_index = middle_index + 1 + bsearch(array[middle_index+1..-1], target)
  elsif middle_element > target
    bsearch(array[0...middle_index], target)
  else
    # found the target
    middle_index
  end
end

# p bsearch([1, 2, 3], 1) # => 0
# p bsearch([2, 3, 4, 5], 3) # => 1
# p bsearch([2, 4, 6, 8, 10], 6) # => 2
# p bsearch([1, 3, 4, 5, 9], 5) # => 3
# p bsearch([1, 2, 3, 4, 5, 6], 6) # => 5


def merge_sort(arr)
  return arr if arr.length <= 1

  left_half = arr.take(arr.length/2)
  right_half = arr.drop(arr.length/2)

  merge(merge_sort(left_half), merge_sort(right_half))
end

def merge(left, right)
  res = []
  until left.empty? || right.empty?
    res << ((left.first < right.first) ? left.shift : right.shift)
  end
  res + left + right
end


# p merge_sort([6,3,24,1,25,7])


def subsets(arr)
  return [[]] if arr == nil || arr.length == 0
  subs = subsets(arr.take(arr.count-1))
  subs.concat(subs.map { |sub| sub + [arr.last] })
end
p subsets([]) # => [[]]
p subsets([1]) # => [[], [1]]
p subsets([1, 2]) # => [[], [1], [2], [1, 2]]
p subsets([1, 2, 3])

