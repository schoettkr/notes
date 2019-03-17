def select_even_nums(numbers)
  numbers.select(&:even?)
end

def reject_puppies(dogs)
  dogs.reject { |dog| dog["age"] <= 2}
end

def count_positive_subarrays(matrix)
  matrix.count { |arr| arr.sum > 0 }
end

def aba_translate(word)
  vowels = "aeiou"
  translation = ""
  word.each_char do |char|
    translation += char
    translation += ("b" + char) if vowels.include?(char)
  end
  translation
end

def aba_array(arr)
  arr.map { |word| aba_translate(word) }
end
