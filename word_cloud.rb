module WordCloud
  
  class WordArray
    
    attr_accessor :hash
    
    # accepts hash of values
    def initialize(h)
      
      unless h.class == Hash
        fail 'accepts only Hash as a parameter'
      end
      @hash = h
      
    end
    
    
    def make_js_variable
      
      js_code = "var word_array = [\n"
      self.hash.each do
        |key, value|
        js_code << "\t\t{ text: \"#{key}\", weight: #{value}},\n"
      end
      js_code << '];'
      
    end
    
    
    def write_js(filename, div_id)
      
      text = self.make_js_variable + "\n\n"
      text << "$(function() {
        $(\"##{div_id}\").jQCloud(word_array);
      });"
      
      File.open(filename, 'w') { |file| file.write(text) }
      
    end
    
  end
  
end 