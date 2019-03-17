class Dog
  def initialize(name, breed, age, bark, favorite_foods)
    @name = name
    @breed = breed
    @age = age
    @bark = bark
    @favorite_foods = favorite_foods
  end

  def bark
    @age > 3 ? @bark.upcase : @bark.downcase
  end

  def favorite_food?(food)
    @favorite_foods.any? { |el| el.downcase == food.downcase}
  end

  # Getters
  def name
    @name
  end

  def breed
    @breed
  end

  def age
    @age
  end

  def favorite_foods
    @favorite_foods
  end

  # Setters
  def age=(age)
    @age = age
  end
end
