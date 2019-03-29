class Node
  attr_reader :key
  attr_accessor :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    @prev.next = @next
    @next.prev = @prev
    self.next = nil
    self.prev = nil

  end
end

class LinkedList
  include Enumerable
  attr_reader :head, :tail
  def initialize
    @head, @tail = Node.new, Node.new
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next
  end

  def last
    @tail.prev
  end

  def empty?
    @head.next == @tail
  end

  def get(key)
    self.each do |node|
      return node.val if node.key == key
    end
    nil
  end

  def include?(key)
    # get(key) != nil
    any? { |node| node.key == key }
  end

  def append(key, val)
    node = Node.new(key, val)
    node.prev = @tail.prev
    node.next = @tail
    
    @tail.prev.next = node
    @tail.prev = node
  end

  def update(key, val)
    self.each do |node|
      node.val = val if node.key == key
    end
  end

  def remove(key)
    self.each do |node|
      if node.key == key
        # node.prev.next = node.next # Method 1 
        # node.next.prev = node.prev # Method 1
        node.remove # Method 2
        return node
      end
    end
  end

  def each(&prc)
    node = @head.next
    while node != @tail
      prc.call(node)
      node = node.next
    end
  end

  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
