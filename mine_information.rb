require_relative 'github_crawler'
require_relative 'google_api'
require_relative 'lib/word_cloud/word_cloud'
require_relative 'high_chart'


# get number of users per country
s = Tire.search 'github' do
  query { term :_type, 'user' }  
  facet('codes'){ terms :country_code, :size => 200}
end

# transform results into hash
hash_of_results = s.results_to_array('codes')

# transform data to GoogleMapsAPI class
google_maps_data = GoogleMapsAPI::DataContainer.new(hash_of_results)

# write file with js script to draw the map of regions
opt = {"dataMode" => "regions", "width" => "1000px", "height" => "600px"}
google_maps_data.write_js('examples/google_map_charts/map_chart_regions.js', 'map_canvas_regions', options=opt)


# get numbers of users in big cities
s = Tire.search 'github' do
  query do
    boolean do
      must { term :_type, 'user' }
      must_not { term :feature_code, 'PCLI' }
    end
  end
  
  facet('cities'){ terms :geo_name, :size => 50}
    
end

# add coordinates to cities
cities = s.results.facets['cities']['terms']
cities.map! do |city|
  
  s2 = Tire.search 'github' do
    query do
      boolean do
        must { term :_type, 'user'}
        must { term :geo_name, city['term']}
      end
    end
  end
  
  loc = s2.results[0]['location']
  x, y = loc.split(',').map { |crds| crds.to_f}
  city['x'] = x
  city['y'] = y 
  city
end

# cluster near cities
clustered = cluster(cities, 100)  

# transform data to GoogleMapsAPI class
google_maps_data = GoogleMapsAPI::DataContainer.new(clustered)

# write file with js script to draw the map of regions
opt = {"dataMode" => "markers", 'region' => '021', 'colors' => ['0xFF8747', '0xFFB581', '0xc06000'],
  "width" => "1000px", "height" => "600px"}
google_maps_data.write_js('examples/google_map_charts/map_chart_cities.js', 'map_canvas_cities', options=opt)


### get frequency of words in bio of users
s = Tire.search 'github' do
  query { term :_type, 'user'}
  facet('words'){ terms :bio, :size => 150}
end

total_records = s.results.total

# transform results into hash
hash_of_results = s.results_to_hash('words')

# transform data to WordCloud class
word_cloud_data = WordCloud::WordArray.new(hash_of_results)

# write a js file
word_cloud_data.write_js('examples/word_cloud/word_cloud_user_bio.js',
                         'word_cloud_bio' , 'word_cloud1', total_records, 'nr_users')


### get frequency of words in commits
s = Tire.search 'github' do
  query { term :_type, 'commit'}
  facet('words'){ terms :message, :size => 150}
end

total_records = s.results.total

# transform results into hash
hash_of_results = s.results_to_hash('words')

# transform data to WordCloud class
word_cloud_data = WordCloud::WordArray.new(hash_of_results)

# write a js file
word_cloud_data.write_js('examples/word_cloud/word_cloud_commit_msg.js', 
                         'word_cloud_msg', 'word_cloud2', total_records, 'nr_commits')


### numbers of created user acount per day
s = Tire.search 'github' do
  query {term :_type, 'user'}  
  facet('date'){date :created_at, {:interval => 'day'}}  
end 

# transform results into hash with DateTime as keys
hash_of_results = s.results_to_datetime('date')

#transform data to TimeSeriesData class
time_series_data = HighChart::TimeSeriesData.new(hash_of_results)

#write a js file
time_series_data.write_js('examples/high_chart/timeseries_chart_simple.js', 'container1')

time_series_data.insert_days!

time_series_data.write_js('examples/high_chart/timeseries_chart_inserted.js', 'container2')

time_series_data.cummulative_count!

time_series_data.write_js('examples/high_chart/timeseries_chart_cummulative.js', 'container3')


### table of languages used in repos
s = Tire.search 'github' do
  query { term :_type, 'repo'}
  facet('lng'){ terms :language, :size => 50}
end

# transform results into hash with DateTime as keys
hash_of_results = s.results_to_hash('lng')

#transform data to BarChart class
lng_table = HighChart::BarChart.new(hash_of_results)

# write js file with bar chart
lng_table.write_js('examples/high_chart/lng_table.js', 'container')
