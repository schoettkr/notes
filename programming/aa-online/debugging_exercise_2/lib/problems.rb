# Run `bundle exec rspec` and satisy the specs.
# You should implement your methods in this file.
# Feel free to use the debugger when you get stuck.

def largest_prime_factor(num)
  num.downto(2).each do |i|
    return i if (num % i == 0 && is_prime?(i))
  end
end

def is_prime?(num)
  return false if num < 2
  (2...num).each do |i|
    return false if num % i == 0
  end
  return true
end

def unique_chars?(str)
  char_counts = Hash.new(0)
  str.each_char { |c| char_counts[c] +=  1 }
  return char_counts.values.none? { |count| count > 1 }
end


def dupe_indices(arr)
  dupes = Hash.new([])
  arr.each_with_index do |el, i|
    if arr.count(el) > 1
      dupes[el] = [*dupes[el], i]
    end
  end
  dupes
end

def ana_array(arr1, arr2)
  el_count(arr1) == el_count(arr2)
end

def el_count(arr)
  counts = Hash.new(0)
  arr.each { |el| counts[el] += 1 }
  counts
end
