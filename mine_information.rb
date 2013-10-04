require_relative 'github_crawler'
require_relative 'google_api'
require_relative 'word_cloud'
require_relative 'high_chart'
require_relative 'apriori'


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
time_series_data.write_js('examples/timeseries/timeseries_chart_simple.js', 'container1')

time_series_data.insert_days!

time_series_data.write_js('examples/timeseries/timeseries_chart_inserted.js', 'container2')

time_series_data.cummulative_count!

time_series_data.write_js('examples/timeseries/timeseries_chart_cummulative.js', 'container3')



# code to generate pair of users, who collaborate with each other
# uses program apriori
# http://www.borgelt.net/doc/apriori/apriori.html
colab = collaborators_as_transactions('github', 'repo')

trans = Apriori::Transactions.new(colab)

input_file_path = '/tmp/input'
output_file_path = '/tmp/output'

trans.write_file(input_file_path, limit=2)

opt = Apriori::Options.new({:target_type => 'm', :min_size =>2, :max_size => 2, :min_supp => -15, :min_conf => 100, :add_eval => "l", :output_format => " %e"})
item_set = Apriori::call_apriori(input_file_path, output_file_path, opt)
puts "DONE" if item_set
File.delete(input_file_path, output_file_path)

puts item_set.frequency_of_items
