# O(n^2)
def naive_windowed_max_range(arr, w)
  current_max_range = 0
  arr.each_index do |idx|
    window_start = idx
    window_end = idx+w-1
    window = arr[window_start..window_end]
    temp_range = window.max - window.min
    current_max_range = temp_range if temp_range > current_max_range
  end
  current_max_range
end
# p naive_windowed_max_range([1, 0, 2, 5, 4, 8], 2) == 4 # 4, 8
# p naive_windowed_max_range([1, 0, 2, 5, 4, 8], 3) == 5 # 0, 2, 5
# p naive_windowed_max_range([1, 0, 2, 5, 4, 8], 4) == 6 # 2, 5, 4, 8
# p naive_windowed_max_range([1, 3, 2, 5, 4, 8], 5) == 6 # 3, 2, 5, 4, 8



class MyQueue
  attr_reader :size

  def initialize
    @store = []
    @size = 0
  end
  def enqueue(item)
    @size += 1
    @store << item
  end

  def dequeue
    @size -= 1
    @store.shift
  end

  def peek
    @store.first
  end
end

class MyStack
  attr_reader :size

  def initialize
    @store = []
    @size = 0
  end

  def empty?
    @size == 0
  end

  def push(item)
    @size += 1
    @store << item
  end

  def pop
    @size -= 1
    @store.pop
  end

  def peek
    @store.last
  end
end

class StackQueue
  attr_reader :size
  def initialize
    @input = MyStack.new
    @output = MyStack.new
    @size = 0
  end
  def enqueue(item)
    @size += 1
    @input.push(item)
  end
  def dequeue
    if @output.empty?
      @output.push(@input.pop) until @input.empty?
    end
    @size -= 1
    @output.pop
  end
  def empty?
    @input.empty? && output.empty?
  end
end

# sq = StackQueue.new
# sq.enqueue(1)
# sq.enqueue(2)
# sq.enqueue(3)

# p sq.dequeue
# sq.enqueue(4)
# p sq.dequeue
# p sq.dequeue
# p sq.dequeue

class MinMaxStack
  attr_reader :size
  def initialize
    @store = MyStack.new
  end
  def push(item)
    @store.push(
      {
        val: item,
        max: new_max(item),
        min: new_min(item)
      }
    )
  end
  def size
    @store.size
  end
  def empty?
    @store.empty?
  end
  def max
    @store.peek[:max] unless empty?
  end
  def new_max(item)
    @store.empty? ? item : [item, max].max
  end
  def min
    @store.peek[:min] unless empty?
  end
  def new_min(item)
    @store.empty? ? item : [item, min].min
  end
  def pop
    @store.pop
  end
end

class MinMaxStackQueue
  def initialize
    @input = MinMaxStack.new
    @output = MinMaxStack.new
    @size = 0
  end
  def size
    @size
  end
  def enqueue(item)
    @size += 1
    @input.push(item)
  end
  def dequeue
    if @output.empty?
      @output.push(@input.pop[:val]) until @input.empty?
    end
    @size -= 1
    @output.pop
  end
  def empty?
    @output.empty? && @input.empty?
  end
  def max
    [@input.max, @output.max].select { |el| !el.nil? }.max
  end
  def min
    [@input.min, @output.min].select { |el| !el.nil? }.min
  end
end

def good_windowed_max_range(arr, w)
  current_max_range = nil
  min_max_queue = MinMaxStackQueue.new
  k = 0

  arr.each_with_index do |el, idx|
    min_max_queue.enqueue(el)
    min_max_queue.dequeue if min_max_queue.size > w

    if min_max_queue.size == w
      temp_range = min_max_queue.max - min_max_queue.min
      current_max_range = temp_range if !current_max_range || temp_range > current_max_range
    end
  end

  current_max_range
end
p good_windowed_max_range([1, 0, 2, 5, 4, 8], 2) == 4 # 4, 8
p good_windowed_max_range([1, 0, 2, 5, 4, 8], 3) == 5 # 0, 2, 5
p good_windowed_max_range([1, 0, 2, 5, 4, 8], 4) == 6 # 2, 5, 4, 8
p good_windowed_max_range([1, 3, 2, 5, 4, 8], 5) == 6 # 3, 2, 5, 4, 8
