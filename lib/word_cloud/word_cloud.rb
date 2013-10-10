# module to transform table of word frewuencies (given as a hash) to a js file, which will plot word cloud
module WordCloud
  
  class WordArray < Hash
    
    #expects: hash
    def initialize(params={})
      
      params.each do |attr, value|
        self[attr] = value
      end if params
        
    end    
    
    # creates string, including javascript variable
    def make_js_variable(varname)
      
      js_code = "var #{varname} = [\n"
      self.each do
        |key, value|
        js_code << "\t\t{ text: \"#{key}\", weight: #{value}},\n"
      end
      js_code << '];'
      
    end
    
    
    # writes a file - calls function make_js_variable to generate js variable, appedns more code to it a writes it
    # requires name of file, to which the data will be written and id of div in html page, which will contain the word cloud
    # also requires number of records in the database and id of html element, into which they will be written 
    def write_js(filename, varname, div_id, nr_records, div_id_records)
      
      text = self.make_js_variable(varname) + "\n\n"
      text << "$(function() {
        $(\"##{div_id}\").jQCloud(#{varname});
      });\n\n"
      
      # append code, which makes sure, that the number of records in the database is written to corresponding html element
      text << "$(document).ready(function(){
          $(\"##{div_id_records}\").html(\"#{nr_records}\");
      });"
      
      File.open(filename, 'w') { |file| file.write(text) }
      
    end
    
  end
  
end 