class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    resize! if count == num_buckets
    unless include?(key)
      self[key] << key
      @count += 1
      return true
    end
    return false
  end

  def include?(key)
    bucket = self[key]
    bucket.include?(key)
  end

  def remove(key)
    if include?(key)
      @count -= 1
      return self[key].delete(key)
    end
    false
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num.hash % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    oldStore = @store
    @count = 0
    @store = Array.new(num_buckets * 2) { Array.new }
    oldStore.flatten.each { |el| insert(el) }
  end
end
