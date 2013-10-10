# document, which stores response to request
# response is parsed from json to hash
class GeonamesAPI::GeonamesDocument
    
  attr_reader :body
    
  # retrieves content of web page (JSON document) and parses it to hash
  def initialize(adress, geonames_request)
    response = Net::HTTP.get_response(adress, geonames_request)
    jsonDoc = JSON.parse(response.body)
    @body = jsonDoc
  end
    
  # returns only sorted array of hashes
  def sort_by(key)
    self.body["geonames"].sort {|a,b| a["population"] <=> b['population']}.reverse
  end
    
  # returns object of class GeodataAPI::GeonamesDocument
  def sort_by!(key)
    self.body["geonames"].sort! {|a,b| a["population"] <=> b['population']}.reverse
  end
    
  # returns hash
  def get_largest_city
    sorted = self.sort_by("population")
    sorted[0]
  end
    
end