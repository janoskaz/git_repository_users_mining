class GEXF::Graph
  
  # find all closed subgraphs in a graph
  def find_subgraphs
    
    clusters = GEXF::Cluster.new()
    
    self.nodes.each do |n|
      
      # if node already in one of the clusters, skip
      next if clusters.contains_node?(n) 
      # find subgraph with given node
      cl = self.find_subgraph(n)
      # append to array of clusters
      clusters.push(cl)
      
    end
    
    clusters
    
  end
  
  # find subgraph containing given node
  def find_subgraph(n)
    # variables: stack of nodes to check, list of nodes in a subgraph 
    list_of_nodes = []
    nodes_to_check = [n.id]
      
    until nodes_to_check.empty?
      node = nodes_to_check.pop
      nbrs = self.find_neighbors(node)
      nodes_to_check.add_unique!(nbrs - list_of_nodes)
      list_of_nodes.push(node)
    end    
  
    list_of_nodes  
  end
  
  # find all neighbors of given node
  def find_neighbors(node)
    nbrs = []
    self.edges.each do |e|
      nbrs.push(e.target) if e.source == node
      nbrs.push(e.source) if e.target == node
    end
    nbrs
  end
  
end

class GEXF::Cluster < Array
  
  def contains_node?(node)
    self.any? { |arr| arr.include?(node.id)}
  end
  
end

class Array
  
  # appends items from arr, if they are already not present
  def add_unique!(arr)
    arr.each { |item| self.push(item) unless self.include?(item) }
  end
  self
end