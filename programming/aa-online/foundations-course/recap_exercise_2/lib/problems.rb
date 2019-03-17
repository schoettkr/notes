# Write a method, least_common_multiple, that takes in two numbers and returns the smallest number that is a mutiple 
# of both of the given numbers
def least_common_multiple(num_1, num_2)
  (2..num_1*num_2).each do |i|
    return i if i % num_1 == 0 && i % num_2 == 0
  end
end


# Write a method, most_frequent_bigram, that takes in a string and returns the two adjacent letters that appear the
# most in the string.
def most_frequent_bigram(str)
  freqs = Hash.new(0)
  (0...str.length-1).each do |i|
    letter1, letter2 = str[i], str[i+1]
    freqs[letter1+letter2] += 1
  end
  max = freqs.values.max
  freqs.key(max)
end


class Hash
    # Write a method, Hash#inverse, that returns a new hash where the key-value pairs are swapped
    def inverse
      swapped = {}
      self.each { |v,k| swapped[k] = v }
      swapped
    end
end


class Array
    # Write a method, Array#pair_sum_count, that takes in a target number returns the number of pairs of elements that sum to the given target
    def pair_sum_count(num)
      pairs = []
      (0...self.length).each do |index1|
        (index1...self.length).each do |index2|
          pair = [self[index1], self[index2]]
          pairs << pair if pair.sum == num
        end
      end
      pairs.length
    end


    # Write a method, Array#bubble_sort, that takes in an optional proc argument.
    # When given a proc, the method should sort the array according to the proc.
    # When no proc is given, the method should sort the array in increasing order.
    def bubble_sort(&prc)
      # prc ||= Proc.new { |a, b| a < b }
      if prc
        self.sort! { |a,b| prc.call(a, b) }
      else
        self.sort!
      end
    end
end
