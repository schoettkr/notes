require_relative 'p04_linked_list'

class HashMap
  include Enumerable
  attr_accessor :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key).include?(key)
  end

  def set(key, val)
    resize! if @count == num_buckets
    bucket = bucket(key)
    if self.include?(key)
      bucket.update(key, val)
    else
      bucket.append(key, val)
      @count += 1
    end
  end

  def get(key)
    bucket(key).get(key)
  end

  def delete(key)
    res = bucket(key).remove(key)
    @count -= 1 if res.is_a?(Node)
  end

  def each
    @store.each do |bucketList|
      bucketList.each do |node|
        yield [node.key, node.val]
      end
    end
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :inspect, :to_s
  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    oldStore = @store
    @count = 0
    @store = Array.new(num_buckets * 2) { LinkedList.new }
    oldStore.flatten.each do |linkedList|
      linkedList.each { |node| self.set(node.key, node.val) }
    end
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    @store[key.hash % num_buckets]
  end
end
