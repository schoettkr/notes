class Code
  attr_reader :pegs

  POSSIBLE_PEGS = {
    "R" => :red,
    "G" => :green,
    "B" => :blue,
    "Y" => :yellow
  }

  def initialize(chars)
    raise 'Pegs not valid' if !Code.valid_pegs?(chars)

    @pegs = chars.map(&:upcase)
  end

  def self.valid_pegs?(chars)
    chars.all? { |c| POSSIBLE_PEGS.has_key?(c.upcase) }
  end

  def self.random(length)
    Code.new(length.times.map { POSSIBLE_PEGS.keys.sample })
  end

  def self.from_string(str)
    Code.new(str.split(""))
  end

  def [](pos)
    self.pegs[pos]
  end

  def length
    self.pegs.length
  end

  def num_exact_matches(guess)
    exact_matches = 0
    guess.pegs.each_with_index do |char, i|
      exact_matches += 1 if char == self[i]
    end
    exact_matches
  end

  def num_near_matches(guess)
    near_matches = 0
    guess.pegs.each_with_index do |char, i|
      near_matches += 1 if char != self[i] && self.pegs.include?(char)
    end
    near_matches
  end

  def ==(guess)
    self.pegs == guess.pegs
  end

end
