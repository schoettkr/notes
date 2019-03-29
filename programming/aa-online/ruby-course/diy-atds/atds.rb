class Stack
  def initialize
    @stack = []
  end

  def push(el)
    @stack << el
  end

  def pop
    @stack.pop
  end

  def peek
    @stack.last
  end
end

class Queue
  def initialize
    @queue = []
  end

  def enqueue(el)
    @queue << el
  end

  def dequeue
    @queue.shift
  end

  def peek
    @queue.first
  end
end

class Map
  def initialize
    @map = []
  end

  def set(key, value)
    @map.each do |entry|
      if entry[0] == key
      return entry[1] = value
      end
    end
    @map << [key, value]
  end

  def get(key)
    @map.select { |entry| entry[0] == key }
  end

  def delete(key)
    @map.reject! { |entry| entry[0] == key }
  end

  def show
    @map
  end
end
