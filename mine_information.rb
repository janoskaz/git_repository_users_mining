require_relative 'github_crawler'
require_relative 'google_api'
require_relative 'word_cloud'


# get number of users per country
s = Tire.search 'github' do
  query { term :_type, 'user' }  
  facet('codes'){ terms :country_code, :size => 200}
end

# transform results into hash
hash_of_results = s.results_to_hash('codes')

# transform data to GoogleMapsAPI class
google_maps_data = GoogleMapsAPI::DataContainer.new(hash_of_results)

# write file with js script to draw the map of regions
opt = {"dataMode" => "regions", "width" => "1000px", "height" => "600px"}
google_maps_data.write_js('examples/google_map_charts/map_chart_regions.js', 'map_canvas_regions', options=opt)





# get numbers of users in big american cities
s = Tire.search 'github' do
  query do
    boolean do
      must { term :_type, 'user' }
    end
  end
  
  facet('cities'){ terms :geo_name, :size => 50}
    
end

# transform results into hash
hash_of_results = s.results_to_hash('cities')

# transform data to GoogleMapsAPI class
google_maps_data = GoogleMapsAPI::DataContainer.new(hash_of_results)

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
