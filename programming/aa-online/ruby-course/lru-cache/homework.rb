class LRUCache
  def initialize(maxCacheSize)
    @store = []
    @maxCacheSize = maxCacheSize
  end

  def count
    @store.length
  end

  def add(el)

    @store.each_with_index do |val, idx|
      if val == el
        @store.delete_at(idx)
        @store.push(el)
        return
      end
    end

    @store.shift if count == @maxCacheSize
    @store.push(el)
  end

  def show
    @store
  end
end

johnny_cache = LRUCache.new(4)

johnny_cache.add("I walk the line")
johnny_cache.add(5)

johnny_cache.count # => returns 2

johnny_cache.add([1,2,3])
johnny_cache.add(5)
johnny_cache.add(-5)
johnny_cache.add({a: 1, b: 2, c: 3})
johnny_cache.add([1,2,3,4])
johnny_cache.add("I walk the line")
johnny_cache.add(:ring_of_fire)
johnny_cache.add("I walk the line")
johnny_cache.add({a: 1, b: 2, c: 3})


p johnny_cache.show # => prints [[1, 2, 3, 4], :ring_of_fire, "I walk the line", {:a=>1, :b=>2, :c=>3}]
