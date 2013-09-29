require 'octokit'
require 'tire'
require 'curb'
require_relative 'geonames_api'


# is ElasticSearch installed?
def es_running?
  begin
    head = !Curl.head('http://localhost:9200').nil?
  rescue
    puts 'ElasticSearch is probably not installed'
    exit
  end  
end

# does database exist?
def database_exists?(db_name)
  url = 'http://localhost:9200/' + db_name
  header = Curl.head(url).header_str
  code = header =~ /20\d/
  !(code.nil?)
end

# delete database with given name
def delete_database(db_name)
  index = Tire::Index.new(db_name)
  index.delete
  puts "database #{db_name} deleted"
end

# create database, mapping is part of the definition
def create_database(db_name)
  index = Tire::Index.new(db_name)
  index.delete
  index.create :mappings => {
      
      # mapping for user
      :user => {
        :properties => {
          :id           => {:type => 'integer'},
          :type_of_user => {:type => 'string', :analyzer => 'keyword'},
          :login        => {:type => 'string', :analyzer => 'keyword'},
          :address      => {:type => 'string', :analyzer => 'keyword'},
          :location     => {:type => 'geo_point', :lat_lon => 'true', :null_value => 'na'},
          :country_code => {:type => 'string', :analyzer => 'keyword'},
          :geo_name     => {:type => 'string', :analyzer => 'keyword'},
          :feature_code => {:type => 'string', :analyzer => 'keyword'},
          :email        => {:type => 'string', :analyzer => 'pattern'},
          :bio          => {:type => 'string', :analyzer => 'stop'},
          :blog         => {:type => 'string', :analyzer => 'pattern'},
          :public_repos => {:type => 'integer'},
          :followers    => {:type => 'string', :analyzer => 'keyword'},
          :following    => {:type => 'string', :analyzer => 'keyword'},
          :created_at    => {:type => 'date'}
        }
      },
      
      # mapping for repositories
      :repo => {
        :properties => {
          :id            => {:type => 'integer'},
          :repo_name     => {:type => 'string', :analyzer => 'keyword'},
          :repo_fullname => {:type => 'string', :analyzer => 'keyword'},
          :owner         => {:type => 'string', :analyzer => 'keyword'},
          :collaborators => {:type => 'string', :analyzer => 'keyword'},
          :description   => {:type => 'string', :analyzer => 'stop'},
          :created_at    => {:type => 'date'},
          :updated_at    => {:type => 'date'},
          :size          => {:type => 'integer'},
          :language      => {:type => 'string', :analyzer => 'keyword'}
        }
      },
      
      #mapping for commits
      :commit => {
        :properties => {
          :repo_fullname => {:type => 'string', :analyzer => 'keyword'},
          :login         => {:type => 'string', :analyzer => 'keyword'},
          :created_at    => {:type => 'date'},
          :message       => {:type => 'string', :analyzer => 'stop'},
        }
      }
      
    }
    index
end

# class for storing one database document (i.e. one record)
class DatabaseRecord
  
  attr_reader :attributes
  def initialize(type_of_record, h)
    @attributes = h
    @attributes[:type] = type_of_record
  end
  
  def type
    self.attributes[:type]
  end
  
  def to_indexed_json
    @attributes.to_json
  end
  
end

# Take user or repo, as given by Octokit module, and get more info
module Sawyer
  
  class Relation
    
    # list of followers for user
    def get_followers
      arr = self.get.data
      arr.map { |user| user.login }
    end
    
    # list of following for user
    def get_following
      arr = self.get.data
      arr.map { |user| user.login }
    end
    
    # list of collaborators for repository
    def get_collaborators
      arr = self.get.data
      arr.map { |collaborator| collaborator.login }
    end
    
  end
  
  
  class Resource
    
    # transform one USER, as given by Octokit module, and transform it into DatabaseRecord
    def user_to_db
      attribs = self.attrs
            
      loc = attribs[:location]
      
      location = location_from_string(loc)
            
      hash = {
        :id              => attribs[:id],
        :type_of_user    => attribs[:type],
        :login           => attribs[:login],
        :address         => attribs[:location],
        :location        => location[:coords],
        :country_code    => location[:country_code],
        :geo_name        => location[:geo_name],
        :feature_code    => location[:fcode],
        :email           => attribs[:email],
        :bio             => attribs[:bio],
        :blog            => attribs[:blog],
        :public_repos    => attribs[:public_repos],
        :followers       => self.rels[:followers].get_followers,
        :following       => self.rels[:following].get_following,
        :created_at      => attribs[:created_at]
      }
      DatabaseRecord.new( type_of_record = 'user', h = hash )
    end
    
    # transform one REPO, as given by Octokit module, and transform it into DatabaseRecord
    def repo_to_db
      attribs = self.attrs
      
      hash = {
        :id            => attribs[:id],
        :name          => attribs[:name],
        :full_name     => attribs[:full_name],
        :owner         => attribs[:owner][:login],
        :collaborators => self.rels[:collaborators].get_collaborators ,
        :description   => attribs[:description],
        :created_at    => attribs[:created_at],
        :updated_at    => attribs[:updated_at],
        :size          => attribs[:size],
        :language      => attribs[:language]
      }
      DatabaseRecord.new( type_of_record = 'repo', h = hash )
    end
    
    # transform one COMMIT, as given by Octokit module, and transform it into DatabaseRecord
    def commit_to_db(repo)
      attribs = self.attrs[:commit].attrs
      
      hash = {
        :repo       => repo,
        :user       => attribs[:author].attrs[:name],
        :message    => attribs[:message],
        :created_at => attribs[:author].attrs[:date],
      }
      DatabaseRecord.new( type_of_record = 'commit', h = hash )
    end
        
  end
  
end

# take name of repo, get all commits and map them to DatabaseRecords
def commits_to_db(repo)
  commits = Octokit.commits(repo)
  commits.map! { |commit| commit.commit_to_db(repo) }
end

# functions to crawl github api, get informations about users/repos/sommits and store them in a database
module Octokit
  
  # go through users and add them to database
  def self.all_users_to_db(database, last_user, upper_limit)
    
    id_user = last_user
    
    until id_user > upper_limit do
      users = Octokit.all_users(:since => id_user)
  
      users.each do |user|
        begin
          user_name = user.login
          record = Octokit.user(user_name).user_to_db
          database.store(record)
          id_user = user.id
        # in case user does not exist (can happen), skip
        rescue
          next
        end
      end
      
    end
      
  end
  
  # add repositories and their commits to database
  def self.all_repos_to_db(database, last_repo, upper_limit)
    
    id_repo = last_repo
    
    until id_repo > upper_limit do
      repos = Octokit.all_repositories(:since => id_repo)
      
      repos.each do |repo|
        begin
          repo_name = repo.full_name
          commits = commits_to_db(repo_name)
          
          record = Octokit.repository(repo_name).repo_to_db
          database.store(record)
          
          commits.each { |commit| database.store(commit) }
          id_repo = repo.id
        # in case a repo does not exist, skip
        rescue
          next
        end
        
      end
    end
    
  end
  
end


# get number of documents in a given database, with given mapping
def number_of_stored_documents(db_name, mapping)
  s = Tire.search db_name, :search_type => 'count' do
    query { term :_type, mapping }
  end
  s.results.total
end

# najdi id posledniho ulozeneho zaznamu v danem mappingu
def last_id(db_name, mapping)
  s = Tire.search db_name do
    query { term :_type, mapping }
    facet 'max_id' do
      statistical :id
    end
  end
  s.results.facets['max_id']['max']
end


# method to get largest city in a hash
def get_user_location(location, hash_of_params)
  
  # try to find exact match on name of country 
  formatted_location = location.downcase.gsub(',','').gsub(' ','+')
  hash_of_params[:name_equals] = formatted_location
  hash_of_params[:feature_class] = 'A'
  hash_of_params[:feature_code] = 'PCLI'
  
  request = GeonamesAPI::GeonamesRequest.new(hash_of_params)
  doc = GeonamesAPI::GeonamesDocument.new('api.geonames.org',request.make_request)
  
  # if there is no exact match on country name, try to find exact match on populated place name
  if doc.body["totalResultsCount"] == 0
    hash_of_params.delete(:name_equals)
    hash_of_params.delete(:feature_code)
    hash_of_params[:feature_class] = 'P'
    hash_of_params[:q] = formatted_location
    
    
    request = GeonamesAPI::GeonamesRequest.new(hash_of_params)
    doc = GeonamesAPI::GeonamesDocument.new('api.geonames.org',request.make_request)
  end
  
  # if there is no exact match, find all partial matches
  # example> exact match is found for 'san francisco', but not for 'san francisco, ca'
  if doc.body["totalResultsCount"] == 0
    hash_of_params.delete(:name_equals)
    hash_of_params[:q] = formatted_location
    
    request = GeonamesAPI::GeonamesRequest.new(hash_of_params)
    doc = GeonamesAPI::GeonamesDocument.new('api.geonames.org',request.make_request)
  end
  
  # if the place has not been found, return nil
  if doc.body["totalResultsCount"] == 0
    return nil
  end
    
  doc.get_largest_city
    
end

# method to get coordinates and country name of a given place
def location_from_string(string)
  
  unless string.nil? || string==''
    params = {:max_rows => 3, :username => 'username', :password => 'password', :feature_class => 'P'}
    location = get_user_location(string, params)
    
    unless location.nil?
      coords = [location["lng"], location["lat"]]
      coords_formated = coords.join(',')
      country_code = location["countryCode"]
      geo_name = location["name"]
      fcode = location["fcode"]
    else
      coords_formated = nil
      country_code = nil
      geo_name = nil
      fcode = nil
    end        
    
  else
    coords_formated = nil
    country_code = nil
    geo_name = nil
    fcode = nil
  end
  
  {:coords => coords_formated, :country_code => country_code, :geo_name => geo_name, :fcode => fcode}
  
end


# take results of a Tire search and transform them to hash
# expects: results of search in Tire of class Tire::SEARCH:SEARCH
# designed to work with frequency table of words (number of users per country)
module Tire
  module Search
    class Search
      
      def results_to_hash(name)
        hash = Hash.new()
        arr = self.results.facets[name]["terms"]
        arr.each do
          |item|
          key = item["term"]
          value = item["count"]
          hash[key] = value 
        end
        hash
      end
      
    end
  end
end