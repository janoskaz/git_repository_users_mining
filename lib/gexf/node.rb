class GEXF::Node
    
    attr_accessor :id, :label, :attributes, :viz_size, :viz_color, :viz_position
    
    #expects: hash
    def initialize(params={})
      
      unless (params.has_key?(:id) || params.has_key?(:label)) 
        puts 'Node must have an id and label'
        exit
      end
      
      params.each do |attr, value|
        self.public_send("#{attr}=", value)
      end if params
      
    end
    
    # write piece of xml
    def to_xml
      
      text = "<node id=\"#{self.id}\" label=\"#{self.label}\">\n"
      
      unless self.attributes.nil?
        text << "\t<attvalues>\n"
        self.attributes.each do |key, value|
          text << "\t\t<attvalue for=\"#{key}\" value=\"#{value}\"></attvalue>\n"
        end
        text << "\t</attvalues>\n"
      end
      
      unless self.viz_size.nil?
        text << "\t<viz:size value=\"#{self.viz_size}\"/>\n"
      end
      
      unless self.viz_color.nil?
        text << "\t<viz:color b=\"#{self.viz_color[:b]}\" g=\"#{self.viz_color[:g]} r=\"#{self.viz_color[:r]}\"\"/>\n"
      end
      
      unless self.viz_position.nil?
        text << "\t<viz:position x=\"#{self.viz_position[:x]}\" y=\"#{self.viz_position[:z]}\"/>\n"
      end
      
      text << "</node>\n"
      text      
    end
    
  end