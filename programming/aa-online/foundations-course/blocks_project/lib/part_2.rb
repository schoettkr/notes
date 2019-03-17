
def all_words_capitalized?(words)
  words.all? { |word| word == word.capitalize}
end

def no_valid_url?(urls)
  valid_domains = ['.com', '.net', '.io', '.org']
  urls.none? { |url| url.end_with?(*valid_domains)}
end

def any_passing_students?(students)
  students.any? { |student| student[:grades].sum / student[:grades].length.to_f >= 75 }
end
