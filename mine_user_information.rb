require_relative 'functions'
require_relative 'google_api'

# get number of users per country
s = Tire.search 'github' do
  query { term :_type, 'user' }  
  facet('codes'){ terms :country_code, :all_terms=>true}
end

# transform results into hash
hash_of_results = s.results_to_hash

# transform data to GoogleMapsAPI class
google_maps_data = GoogleMapsAPI::DataContainer.new(hash_of_results)

# write file with js script to draw the map of regions
google_maps_data.write_js_regions('map_chart.js')
