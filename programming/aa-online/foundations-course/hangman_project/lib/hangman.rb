class Hangman
  DICTIONARY = ["cat", "dog", "bootcamp", "pizza"]

  def self.random_word
    DICTIONARY.sample
  end

  def initialize
    @remaining_incorrect_guesses = 5
    @secret_word = Hangman.random_word()
    @guess_word = Array.new(@secret_word.length, '_')
    @attempted_chars = []
  end

  def remaining_incorrect_guesses 
    @remaining_incorrect_guesses 
  end

  def guess_word
    @guess_word
  end

  def attempted_chars
    @attempted_chars
  end

  def remaining_incorrect_guesses
    @remaining_incorrect_guesses
  end

  def already_attempted?(char)
    @attempted_chars.include?(char)
  end

  def get_matching_indices(char)
    indices = []
    @secret_word.each_char.with_index do |c, i|
      indices << i if c == char
    end
    indices
  end

  def fill_indices(char, indices)
    indices.each { |i| @guess_word[i] = char }
  end

  def try_guess(char)
    if (already_attempted?(char))
      puts "that has already been attempted"
      return false
    end
    matches = get_matching_indices(char)
    fill_indices(char, matches)
    @attempted_chars << char
    @remaining_incorrect_guesses -= 1 if matches.length == 0
    true
  end

  def ask_user_for_guess
    puts "Enter a char: "
    guess = gets.chomp
    try_guess(guess)
  end

  def win?
    if @guess_word == @secret_word.split("")
      puts "WIN"
      return true
    end
    false
  end

  def lose?
    if @remaining_incorrect_guesses == 0
      puts "LOSE"
      return true
    end
    false
  end

  def game_over?
    if (win? || lose?)
      puts @secret_word
      return true
    end
    false
  end

end
