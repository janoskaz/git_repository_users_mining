module GoogleMapsAPI
  
  class DataContainer < Array

    # creates variable data, which is a DataTable
    # returns string with js code
    def js_draw_map
      js_code = "var data = google.visualization.arrayToDataTable([\n"
      #js_code << "\t['Country', 'Users'],\n"
      
      #names of columns
      if self[0].size == 2
        js_code << "\t['Country', 'Users'],\n"
      else
        js_code << "\t['X', 'Y', 'Users', 'Populated Area'],\n"
      end
      
      # input data
      self.each do
        |h|
        if h.size == 2
          js_code << "\t\t[\'#{h['term']}\', #{h['count']}],\n"
        elsif h.size == 4
          js_code << "\t\t[#{h['y']}, #{h['x']}, #{h['count']}, \'#{h['term']}\'],\n"
        end
      end
      js_code << "\t]);\n"
    end
    
    # creates file with js code to be calles by from html page
    # calls function js_draw_map to create variable data, which is appended to the rest of the code
    def write_js(filename, div_id, options={})
      text = "google.load('visualization', '1', {'packages': ['geomap']});
   google.setOnLoadCallback(drawMap);\n\n"
      text << "function drawMap() {\n"
      text << self.js_draw_map
      text << "\tvar options = {};\n"
      
      unless options.empty?
        options.each do |key, value| 
          val = value.is_a?(Array) ? '[' + value.join(', ') + ']' : "'#{value}'"
          text << "options['#{key}'] = #{val};\n" 
        end
      end
      
      text << "var container = document.getElementById('#{div_id}');
      var geomap = new google.visualization.GeoMap(container);
      geomap.draw(data, options);\n};"
      
      File.open(filename, 'w') { |file| file.write(text) }
    end
    
  end
  
end