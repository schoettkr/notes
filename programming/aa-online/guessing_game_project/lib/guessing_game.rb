class GuessingGame
  def initialize(min, max)
    @secret_num = rand(min..max)
    @num_attempts = 0
    @game_over = false
  end

  def check_num(number)
    @num_attempts += 1
    if (@secret_num == number)
      @game_over = true
      puts "You win"
    elsif number < @secret_num
      puts "Too small"
    else
      puts "Too big"
    end
  end

  def ask_user
    puts "Enter a number: "
    guess = gets.chomp.to_i
    check_num(guess)
  end

  def game_over?
    @game_over
  end

  def num_attempts
    @num_attempts
  end
  
end
