class GEXF::Nodeset < Array
  
  def to_xml
    text = "<nodes count=\"#{self.size}\">\n"
    
    self.each { |node| text << node.to_xml}
    
    text << "</nodes>\n"
  end
  
end