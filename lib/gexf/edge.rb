class GEXF::Edge
  
  attr_accessor :id, :source, :target, :attributes
  
  #expects: hash
  def initialize(params={})
    
    unless (params.has_key?(:id) || params.has_key?(:source) || parame.has_key?(:target)) 
      puts 'Node must have an id, source and target'
      exit
    end
      
    params.each do |attr, value|
      self.public_send("#{attr}=", value)
    end if params
      
  end
    
  # write piece of xml
  def to_xml
    
    text = "<edge id=\"#{self.id}\" source=\"#{self.source}\" target=\"#{self.target}\">\n"
    
    unless self.attributes.nil?
      text << "\t<attvalues>\n"
      self.attributes.each do |key, value|
        text << "\t\t<attvalue for=\"#{key}\" value=\"#{value}\"></attvalue>\n"
      end
      text << "\t</attvalues>\n"
    end
    
    text << "</edge>\n"
    text      
    
  end
  
end  