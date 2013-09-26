require 'net/http'
require 'json'

module GeonamesAPI
  
  class GeonamesRequest
    
    attr_accessor :formatted, :username, :password, :q, :feature_code, :feature_class,
                  :max_rows, :name_equals
    
    #expects: hash
    def initialize(params={})
      
      params.each do |attr, value|
        self.public_send("#{attr}=", value)
      end if params
      
    end
    
    # created string with html request
    def make_request
      
      request = '/searchJSON?'
      request << '&q=' + self.q                          unless self.q.nil?
      request << '&name_equals=' + self.name_equals      unless self.name_equals.nil?
      request << '&featureCode=' + self.feature_code     unless self.feature_code.nil?
      request << '&featureClass=' + self.feature_class   unless self.feature_class.nil?
      request << '&formatted=' + self.formatted          unless self.formatted.nil?
      request << '&maxRows=' + self.max_rows.to_s        unless self.max_rows.nil?
      request << '&username=' + self.username            unless self.username.nil?
      request << '&password=' + self.password            unless self.password.nil?
      
      request
      
    end 
        
  end
  
  class GeonamesDocument
    
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
  
end