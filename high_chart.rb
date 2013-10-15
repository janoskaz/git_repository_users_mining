module HighChart
  
  # object TimeSeriesData is hash, where the DateTime object is key and value is number 
  class TimeSeriesData
    
    attr_accessor :hash
    
    def initialize(h)
      
      unless h.class == Hash
        fail 'accepts only Hash as a parameter'
      end
      self.hash = h
      
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
  
  ### class to create bar chart
  class BarChart < Hash

    def initialize(params={})
      
      unless params.class == Hash
        fail 'accepts only Hash as a parameter'
      end
      
      params.each do |attr, value|
        self[attr] = value
      end if params
        
    end  
    
    # creates categories, which are plotted under the graph
    def make_categories
      
      text = "categories: [\n"
      
      self.keys.each do |key|
        text << "'#{key}',\n"
      end
      
      text << "]\n"
      
    end
    
    # created key-value pairs informat, which isunderstood by gigh charts
    def make_series
      
      text = "series: [{ 
                data : [\n"
      
      self.values.each do |value|
        text << value.to_s << ', '
      end
      
      text << "] }],"
      
    end
    
    # create js document
    def write_js(filename, div_id)
      
      js_code = "$(function () {
        $(\'\##{div_id}\').highcharts({
            chart: {
                type: \'column\'
            },\n
            title:{text:\'Languages used in repositories\'},
    legend:{
        enabled:false
    },
            plotOptions: {
        column: {
            groupPadding: 0,
            pointPadding: 0,
            borderWidth: 0
        }
    },\n
            xAxis: {"
                
      js_code << self.make_categories << ', '
      
      js_code << "labels:{
            rotation:-90,
            y:40,
            style: {
                fontSize:\'8px\',
                fontWeight:\'normal\',
                color:\'\#333\'
            },
        },
        lineWidth:0,
        lineColor:\'\#999\',
        tickLength:90,
        tickColor:\'\#ccc\',"
      js_code << "},\n" 
      js_code << "yAxis: {
                type: \'logarithmic\',
                title: {
                    text: 'Number of Repositories '
                }
            },\n"
       js_code << self.make_series
       js_code << "});
    });"
      
    File.open(filename, 'w') { |file| file.write(js_code) }  
      
    end
    
  end
  
end