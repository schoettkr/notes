list = [ 0, 3, 5, 4, -5, 10, 1, 90 ]
# Complexity O(n^2)
def my_min_1(arr)
  arr.each do |num|
    return num if arr.all? { |otherNum| otherNum >= num }
  end
end

p my_min_1(list)

# Complexity O(n)
def my_min_2(arr)
  min = arr.first
  arr.each { |num| min = num if num <= min }
  min
end

p my_min_2(list)



def largest_contiguous_subsum1(arr)
  subarrays = []
  arr.each_with_index do |el1, idx1|
    k = idx1
    while k < arr.length
      subarr = []
      i = idx1
      while i <= k
        subarr << arr[i]
        i += 1
      end
      subarrays << subarr
      k += 1
    end
  end
  max_sum = arr.first
  subarrays.each do |subarr|
    subarr_sum = subarr.sum
    if subarr_sum > max_sum
      max_sum = subarr_sum
    end
  end
  max_sum
end

p largest_contiguous_subsum1([5, 3, -7])
p largest_contiguous_subsum1([2, 3, -6, 7, -6, 7, 10])
p largest_contiguous_subsum1([-5, -1, -3])

# O(n) time and O(1) space
def largest_contiguous_subsum2(arr)
  max_sum = arr.first
  max_sum_ending_here = arr.first

  arr.each_with_index do |el, i|
    next if i == 0
    max_sum_ending_here = [el, max_sum_ending_here + el].max
    if (max_sum < max_sum_ending_here)
      max_sum = max_sum_ending_here
    end
  end

  max_sum
end

p largest_contiguous_subsum2([5, 3, -7])
p largest_contiguous_subsum2([2, 3, -6, 7, -6, 7, 10])
p largest_contiguous_subsum2([-5, -1, -3])
