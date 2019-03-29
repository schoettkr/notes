require_relative  "./PolytreeNode"

class KnightPathFinder
  def self.valid_moves(pos)
    x, y = pos
    valid_moves = []

    valid_moves << [x-1, y] if x > 0
    valid_moves << [x, y-1] if  y > 0

    valid_moves << [x+1, y] if x < 7
    valid_moves << [x, y+1] if y < 7

    valid_moves << [x+1, y+1] if x < 7 && y < 7
    valid_moves << [x-1, y-1] if x > 0 && y > 0

    valid_moves << [x+1, y-1] if x < 7 && y > 0
    valid_moves << [x-1, y+1] if x > 0 && y < 7

    valid_moves
  end

  def initialize(starting_position)
    @root_node = PolyTreeNode.new(starting_position)
    @considered_positions = [starting_position]
    build_move_tree
  end

  def build_move_tree
    queue = [@root_node]
    until queue.empty?
      node = queue.shift
      possible_moves = new_move_positions(node.value)
      possible_moves.each do |move|
        newNode = PolyTreeNode.new(move)
        node.add_child(newNode)
        queue.push(newNode)
      end
    end
  end

  def new_move_positions(pos)
    new_moves = KnightPathFinder.valid_moves(pos).reject { |move| @considered_positions.include?(move) }
    @considered_positions.concat(new_moves)
    new_moves
  end

  def find_path(end_pos)
    end_node = @root_node.dfs(end_pos)
    trace_path_back(end_node)
  end

  def trace_path_back(node)
    path = []
    current = node
    while current.value !=  @root_node.value
      path << current.value
      current = current.parent
    end
    path << @root_node.value 
    path.reverse
  end

end

kpf = KnightPathFinder.new([0, 0])
p kpf.find_path([7, 6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
p kpf.find_path([6, 2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]
p kpf.find_path([7, 7]) # => [[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]]
