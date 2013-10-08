class GEXF::Edgeset < Array
  
  def to_xml
    text = "<edges count=\"#{self.size}\">\n"
    
    self.each { |edge| text << edge.to_xml}
    
    text << "</edges>"
  end
  
end