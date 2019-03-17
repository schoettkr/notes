def palindrome?(str)
  (0...str.length/2).each do |i|
    if str[i] != str[-i-1]
      return false
    end
  end
  true
end

def substrings(str)
  substrings = []
  str.each_char.with_index do |c, charIndex|
    subsequentIndex = charIndex + 1
    substrings << c
    while subsequentIndex < str.length
      substrings << str[charIndex..subsequentIndex]
      subsequentIndex += 1
    end
  end
  substrings
end

def palindrome_substrings(str)
  substrings =  substrings(str)
  substrings.select { |substring| substring.length > 1 && palindrome?(substring) }
end
