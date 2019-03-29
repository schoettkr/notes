require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    cached = @map.get(key)
    if cached # move to back of linked list and retrieve
      @store.remove(cached.key)
      update_node!(cached.key, cached.val)
      return cached.val
    else # compute and move to back of linked list + set in map
      eject! if count >= @max
      val = calc(key)
      update_node!(key, val)
      return @store.last.val
    end
  end

  def to_s
    'Map: ' + @map.to_s + '\n' + 'Store: ' + @store.to_s
  end

  private

  def calc(key)
    # suggested helper method; insert an (un-cached) key
    @prc.call(key)
  end

  def update_node!(key, val)
      @store.append(key, val)
      @map.set(key, @store.last)
  end

  def eject!
    deleted_node = @store.remove(@store.first.key)
    @map.delete(deleted_node.key)
  end
end

# times_two = Proc.new  { |num| num * 2 }
# lru = LRUCache.new(2, times_two)
# p lru.get(5).val
# p lru.get(15).val
# p lru.get(6).val
# p lru.get(7).val
# p lru.get(7).val
# p lru.get(5).val
# puts lru
