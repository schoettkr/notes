def hipsterfy(word)
  vowels = "aeiou"
  (word.length-1).downto(0) do |i|
    if (vowels.include?(word[i]))
      word[i] = ""
      return word
    end
  end
  word
end

def vowel_counts(string)
  vowels = "aeiou"
  hash = Hash.new(0)
  string.each_char { |c| hash[c.downcase] += 1 if vowels.include?(c.downcase) }
  hash
end

def caesar_cipher(message, shift)
  alphabet = ("a".."z").to_a
  message.each_char.with_index do |c, i|
    if alphabet.include?(c.downcase)
      shiftedIndex = (alphabet.index(c.downcase) + shift) % alphabet.length
      shiftedChar = alphabet[shiftedIndex]
      message[i] = shiftedChar
    else
      message[i] = c
    end
  end
  message
end
