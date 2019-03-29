class Card
  def initialize(value)
    @value = value
    @showing = false
  end

  def display
    if @showing
      return @value
    else
      return nil
    end
  end

  def hide
    @showing = false
  end

  def reveal
    @showing = true
  end

  def to_s
    @value.to_s
  end

  def showing?
    @showing
  end

  def ==(card)
    self.to_s == card.to_s
  end
end
