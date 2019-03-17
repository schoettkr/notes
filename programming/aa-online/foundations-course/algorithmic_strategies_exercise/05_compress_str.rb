# Write a method, compress_str(str), that accepts a string as an arg.
# The method should return a new str where streaks of consecutive characters are compressed.
# For example "aaabbc" is compressed to "3a2bc".

def compress_str(str)
  arr = str.split("")
  res = ""
  i = 0
  count = 1
  while (i < arr.length)
    if (arr[i] == arr[i+1])
      count += 1
    elsif (count != 1)
      res += count.to_s + arr[i]
      count = 1
    else
      res += arr[i]
    end
    i += 1
  end
  res
end


p compress_str("aaabbc")        # => "3a2bc"
p compress_str("xxyyyyzz")      # => "2x4y2z"
p compress_str("qqqqq")         # => "5q"
p compress_str("mississippi")   # => "mi2si2si2pi"
