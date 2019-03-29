FISHES = ['fish', 'fiiish', 'fiiiiish', 'fiiiish', 'fffish', 'ffiiiiisshh', 'fsh', 'fiiiissshhhhhh']

# O(n^2)
def sluggish(fishes)
  fishes.each do |fish|
    longerThanAll = fishes.all? { |comparingFish| fish.length >= comparingFish.length }
    return fish if longerThanAll
  end
end
p sluggish(FISHES)

# O(n log n)
def dominant(fishes)
  merge_sort(fishes).last
end

def merge_sort(arr)
  return arr if arr.length <= 1
  left = arr[0...arr.length/2]
  right = arr[arr.length/2...arr.length]

  return merge(merge_sort(left), merge_sort(right))
end

def merge(a, b)
  sorted = []
  until a.empty? || b.empty?
    if a.first.length < b.first.length # comparing string lengths
      sorted.push(a.shift)
    else
      sorted.push(b.shift)
    end
  end
  sorted += a + b
end

p dominant(FISHES)

# O(n)
def clever(fishes)
  longest = ""
  fishes.each do |fish|
    longest = fish if fish.length > longest.length
  end
  longest
end

p dominant(FISHES)

TILES = ["up", "right-up", "right", "right-down", "down", "left-down", "left",  "left-up" ]

# O(n)
def slow_dance(direction, tiles)
  tiles.each_with_index { |tile, idx| return idx if tile == direction}
end

p slow_dance("up", TILES)
p slow_dance("right-down", TILES)

# O(1)
IMPROVED_TILES =  {
  "up" => 0,
  "right-up" => 1,
  "right" => 2,
  "right-down" => 3,
  "down" => 4,
  "left-down" => 5,
  "left" => 6,
  "left-up" => 7
}
def fast_dance(direction, tiles)
  return tiles[direction]
end
p fast_dance("up", IMPROVED_TILES)
p fast_dance("right-down", IMPROVED_TILES)
