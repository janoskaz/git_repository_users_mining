module GoogleMapsAPI
  
  class DataContainer
    
    attr_accessor :hash
    
    # accepts hash of values
    def initialize(h)
      unless h.class == Hash
        fail 'accepts only Hash as a parameter'
      end
      @hash = h
    end
    
    def js_draw_map
      js_code = "var data = google.visualization.arrayToDataTable([\n"
      js_code << "\t['Country', 'Users'],\n"
      self.hash.each do
        |key, value|
        js_code << "\t\t['#{key}', #{value}],\n"
      end
      js_code << "\t]);\n"
    end
    
    def write_js_regions(filename)
      text = "google.load('visualization', '1', {'packages': ['geomap']});
   google.setOnLoadCallback(drawMap);\n\n"
      text << "function drawMap() {\n"
      text << self.js_draw_map
      text << "\tvar options = {};
      options['dataMode'] = 'regions';
      
      var container = document.getElementById('map_canvas');
      var geomap = new google.visualization.GeoMap(container);
      geomap.draw(data, options);\n};"
      
      File.open(filename, 'w') { |file| file.write(text) }
    end
    
  end
  
end