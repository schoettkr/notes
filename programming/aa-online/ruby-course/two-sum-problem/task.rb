arr = [0, 1, 5, 7]

# O(n^2)
def bad_two_sum?(arr, target_sum)
  arr.each_with_index do |el1, idx1|
    arr.each_with_index do |el2, idx2|
      next unless idx2 > idx1
      return true if el1 + el2 == target_sum
    end
  end
  false
end

p bad_two_sum?(arr, 6) # => should be true
p bad_two_sum?(arr, 10) # => should be false

# O(n log n)
def okay_two_sum?(arr, target_sum)
  arr.sort!
  l = arr.length / 2 - 1
  r = arr.length / 2

  while l >= 0 && r < arr.length
    smaller_num = arr[l]
    larger_num = arr[r]
    if smaller_num + larger_num == target_sum
      return true
    elsif smaller_num + larger_num < target_sum
      r += 1
    else
      l -= 1
    end
  end
  false
end

p okay_two_sum?(arr, 6) # => should be true
p okay_two_sum?(arr, 10) # => should be false

# O(n)
def good_two_sum?(arr, target_sum)
  hash = Hash.new(false)
  # arr.each { |num| hash[num] = true }
  # arr.any? do |num|
  #   summand = target_sum - num
  #   next if summand == num
  #   hash[target_sum - num]
  # end

  # improvement
  arr.each do |el|
    return true if hash[target_sum - el]
    hash[el] = true
  end
  false
end

p good_two_sum?(arr, 6) # => should be true
p good_two_sum?(arr, 10) # => should be false
