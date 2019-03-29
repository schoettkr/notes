require "byebug"
# O(n!)
def first_anagram?(str1, str2)
  anagrams = anagrams(str1)
  anagrams.include?(str2)
end

def anagrams(string)
  return [string] if string.length <= 1
  prev_anagrams = anagrams(string[0...-1])
  new_anagrams = []

  prev_anagrams.each do |anagram|
    (0..anagram.length).each do |pos|
      variation = anagram.dup.insert(pos, string[-1])
      new_anagrams << variation
    end
  end

  new_anagrams
end

p first_anagram?("gizmo", "sally")
p first_anagram?("elvis", "lives")

# O(n^2)
def second_anagram?(str1, str2)
  str2 = str2.split("")
  str1.each_char do |c|
    idx = str2.find_index(c)
    if idx
      str2.delete_at(idx)
    else
      return false
    end
  end
  return str2.empty?
end

p second_anagram?("gizmo", "sally")
p second_anagram?("elvis", "lives")

# O(n log(n))
def third_anagram?(str1, str2)
  str1, str2 = str1.split("").sort, str2.split("").sort
  str1 == str2
end

p third_anagram?("gizmo", "sally")
p third_anagram?("elvis", "lives")


# O(n)
def fourth_anagram?(str1, str2)
  hash1 = Hash.new(0)
  hash2 = Hash.new(0)
  [str1, str2].map do |str|
    str.each_char do |c|
      hash1[c] += 1 if str == str1
      hash2[c] += 1 if str == str2
    end
  end
  hash1 == hash2
end

p fourth_anagram?("gizmo", "sally")
p fourth_anagram?("elvis", "lives")

def fourth_anagram_single_hash?(str1, str2)
  hash = Hash.new(0)
  str1.each_char do |c|
    hash[c] += 1
  end
  str2.each_char do |c|
    hash[c] -= 1
  end
  # hash.values.uniq == [0]
  hash.values.all? { |val| val == 0}
end

p fourth_anagram_single_hash?("gizmo", "sally")
p fourth_anagram_single_hash?("elvis", "lives")
