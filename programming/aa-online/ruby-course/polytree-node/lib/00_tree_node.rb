class PolyTreeNode
  attr_reader :value, :parent, :children

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(parent)
    @parent.children.reject! { |child| child == self } if @parent
    if parent
      @parent = parent
      parent.children << self
    else
      @parent = nil
    end
  end

  def add_child(child_node)
    child_node.parent = self
  end

  def remove_child(child_node)
    if child_node && !self.children.include?(child_node)
      raise "Not a child"
    end

    child_node.parent = nil
  end

  def dfs(target_value)
    return self if self.value == target_value # current node holds the value we're searching for

    self.children.each do |child|
      res = child.dfs(target_value)
      return res unless res.nil?
    end

    nil
  end

  def bfs(target_value)
    queue = []
    queue.push(self)

    until queue.empty?
      node = queue.shift
      return node if node.value == target_value
      queue.push(*node.children)
    end

    nil
  end

end
