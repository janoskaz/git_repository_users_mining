class GEXF::Graph
  
  attr_reader :edgetype, :idtype, :mode, :nodes, :edges
  
  public
  def initialize(params={})
    @nodes = GEXF::Nodeset.new()
    @edges = GEXF::Edgeset.new()
    @edgetype = params[:defaultedgetype] || :undirected
    @idtype = params[:idtype] || :string
    @mode = params[:mode] || :static
  end
  
  def add_node(n)
    @nodes.push(n)
  end
  
  def add_edge(e)
    @edges.push(e)
  end
  
  def to_xml
    
    text = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<gexf xmlns=\"http://www.gephi.org/gexf\" xmlns:viz=\"http://www.gephi.org/gexf/viz\">
  <graph defaultedgetype=\"#{self.edgetype}\" idtype=\"#{self.idtype}\" type=\"#{self.mode}\">"
  
  text << self.nodes.to_xml
  
  text << self.edges.to_xml
  
  text << "</graph>
</gexf>"
    
  end
  
  def write(filename)
    
    f = File.open(filename, 'w')
    begin
      f << self.to_xml
    ensure
      f.close
    end
    
    
  end
  
end