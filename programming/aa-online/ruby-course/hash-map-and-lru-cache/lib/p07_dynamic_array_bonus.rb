class StaticArray
  attr_reader :store

  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    self.store[i]
  end

  def []=(i, val)
    validate!(i)
    self.store[i] = val
  end

  def length
    self.store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, self.store.length - 1)
  end
end

class DynamicArray
  include Enumerable
  attr_accessor :count

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    @store[i]
  end

  def []=(i, val)
    @store[i] = val
  end

  def capacity
    @store.length
  end

  def include?(val)
    self.each do |el|
      return true if el == val
    end
    false
  end

  def push(val)
    resize! if count  == capacity
    @store[count] = val
    @count += 1
  end

  def unshift(val)
  end

  def pop
    return nil if @count == 0
    last_val = @store[@count-1]
    @store[@count-1] = nil
    @count -= 1
    last_val
  end

  def shift
    return nil if @count == 0
    first_val = @store[0]
    @count -= 1
    
    return first_val
  end

  def first
    @store[0]
  end

  def last
    @store[@count-1]
  end

  def each
    @store.store.each do |el|
      yield el
    end
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    # ...
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    oldStore = @store
    @count = 0
    @store = Array.new(capacity*2)
    oldStore.store.each { |val| self.push(val) }
  end
end
