def partition(arr, num)
  less = []
  more = []
  arr.each do |el|
    if el < num
      less << el
    else
      more << el
    end
  end
  return [less, more]
end

def merge(h1, h2)
  merged = {}
  h1.each { |k, v| merged[k] = v }
  h2.each { |k, v| merged[k] = v }
  merged
end

def censor(sentence, words)
  censored = sentence.split.map do |word|
    if (words.include?(word.downcase))
      replace_vowels(word)
    else
      word
    end
  end
  censored.join(" ")
end

def replace_vowels(word)
  vowels = "aeiou"
  word.each_char.with_index { |c, i| word[i] = '*' if vowels.include?(c.downcase) }
  word
end

def power_of_two?(num)
  num & num-1 == 0
end
