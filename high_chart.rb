module HighChart
  
  # object TimeSeriesData is hash, where the DateTime object is key and value is number 
  class TimeSeriesData
    
    attr_accessor :hash
    
    def initialize(h)
      
      unless h.class == Hash
        fail 'accepts only Hash as a parameter'
      end
      @hash = h
      
    end
    
    def size
      self.hash.size
    end
    
    # make rugular time series with time stamp one day
    def insert_days!
      
      #make range from first to last day
      min = self.hash.keys.min
      max = self.hash.keys.max
      rng = min..max
      
      h = Hash.new()
      
      rng.each do
        |i|
        if self.hash.has_key?(i )
          h[i] = self.hash[i]
        else
          h[i] = 0
        end
      end
      
      self.hash = h 
    end
    
    # calculate summulative sum over time - dangerous
    def cummulative_count!
      
      sum = 0
      self.hash.each do 
        |key, value| 
        self.hash[key] = (sum += value)
      end
      
    end
    
    # make series of values to be ploted - only data, not the whole code
    def make_js_variable
      
      text = "series: [{
            data: [\n\n"
      
      self.hash.each do
        |key, value|
        text << "[Date.UTC#{key.strftime('(%Y ,%m, %d)')}, #{value}],\n"
      end
      text <<  "]
        }] "      
      
      text
    end
    
    #write js file with all code
    def write_js(filename, div_id)
      
      text = "$(function () {
        $('##{div_id}').highcharts({
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: {
                day: '%e of %b'
            }
        },"
        
      text << self.make_js_variable
      text << "});
        });"
    
      File.open(filename, 'w') { |file| file.write(text) }
    
    end
        
  end
  
end