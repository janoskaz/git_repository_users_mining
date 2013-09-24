require 'octokit'
require 'tire'
require 'curb'
require 'geonames'

# je nainstalovany elasticsearch?
def es_running?
  begin
    head = !Curl.head('http://localhost:9200').nil?
  rescue
    puts 'ElasticSearch is probably not installed'
    exit
  end  
end

# existuje databaze?
def database_exists?(db_name)
  url = 'http://localhost:9200/' + db_name
  header = Curl.head(url).header_str
  code = header =~ /20\d/
  !(code.nil?)
end

def create_database(db_name)
  index = Tire::Index.new(db_name)
  index.delete
  index.create :mappings => {
      
      # mapping pro uzivatele
      :user => {
        :properties => {
          :id           => {:type => 'integer'},
          :type_of_user => {:type => 'string', :analyzer => 'keyword'},
          :login        => {:type => 'string', :analyzer => 'keyword'},
          :address      => {:type => 'string', :analyzer => 'snowball'},
          :location     => {:type => 'geo_point', :lat_lon => 'true', :null_value => 'na'},
          :country_code => {:type => 'string', :analyzer => 'keyword'},
          :geo_name     => {:type => 'string', :analyzer => 'keyword'},
          :email        => {:type => 'string', :analyzer => 'pattern'},
          :bio          => {:type => 'string', :analyzer => 'snowball'},
          :blog         => {:type => 'string', :analyzer => 'pattern'},
          :public_repos => {:type => 'integer'},
          :followers    => {:type => 'string', :analyzer => 'keyword'},
          :following    => {:type => 'string', :analyzer => 'keyword'},
          :created_at   => {:type => 'date'}
        }
      },
      
      # mapping pro repositare
      :repo => {
        :properties => {
          :id            => {:type => 'integer'},
          :repo_name     => {:type => 'string', :analyzer => 'keyword'},
          :repo_fullname => {:type => 'string', :analyzer => 'keyword'},
          :owner         => {:type => 'string', :analyzer => 'keyword'},
          :collaborators => {:type => 'string', :analyzer => 'keyword'},
          :description   => {:type => 'string', :analyzer => 'snowball'},
          :created_at    => {:type => 'date'},
          :updated_at    => {:type => 'date'},
          :size          => {:type => 'integer'},
          :language      => {:type => 'string', :analyzer => 'keyword'}
        }
      },
      
      #mapping pro commity
      :commit => {
        :properties => {
          :repo_fullname => {:type => 'string', :analyzer => 'keyword'},
          :login         => {:type => 'string', :analyzer => 'keyword'},
          :created_at    => {:type => 'date'},
          :message       => {:type => 'string', :analyzer => 'snowball'},
        }
      }
      
    }
    index
end

# trida pro vytvoreni zaznamu v databazi
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

# Vzit jednoho uzivatele a pretransformovat ho do tridy DatabaseRecord
module Sawyer
  
  class Relation
    
    # seznam followeru z objektu vraceneho github_api
    def get_followers
      arr = self.get.data
      arr.map { |user| user.login }
    end
    
    # seznam following z objektu vraceneho github_api
    def get_following
      arr = self.get.data
      arr.map { |user| user.login }
    end
    
    # seznam collaborators z objektu repo
    def get_collaborators
      arr = self.get.data
      arr.map { |collaborator| collaborator.login }
    end
    
  end
  
  class Resource
    
    # transformace uzivatele do DatabaseRecord
    def user_to_db
      attribs = self.attrs
      
      loc = attribs[:location]
      unless loc.nil? || loc==''
        location = get_location(loc)
        coords = [location[:lon], location[:lat]]
        coords_formated = coords.join(',')
        country_code = location[:country]
        geo_name = location[:name]
      else
        coords_formated = nil
        country_code = nil
        geo_name = nil
      end
      
      
      hash = {
        :id => attribs[:id],
        :type_of_user => attribs[:type],
        :login => attribs[:login],
        :address => attribs[:location],
        :location => coords_formated,
        :country_code => country_code,
        :geo_name => geo_name,
        :email => attribs[:email],
        :bio => attribs[:bio],
        :blog => attribs[:blog],
        :public_repos => attribs[:public_repos],
        :followers => self.rels[:followers].get_followers,
        :following => self.rels[:following].get_following,
        :created_at => attribs[:created_at]
      }
      DatabaseRecord.new( type_of_record = 'user', h = hash )
    end
    
    # transformace repozitare do DatabaseRecord
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
    
    # transformace jednoho commitu do db
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

# transformace vsech commitu do DatabaseRecord
def commits_to_db(repo)
  commits = Octokit.commits(repo)
  commits.map! { |commit| commit.commit_to_db(repo) }
end

# funkce na pridavani uzivatelu a repozitaru
module Octokit
  
  # prochazet vsechny uzivatele jednoho po druhhem a pridavat je do databaze
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
        # osetreni vyjimky - muze se stat, ze user neexistuje/nelze ho najit -> preskocit
        rescue
          next
        end
      end
      
    end
      
  end
  
  # pridavani repozitaru a commitu do databaze
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
        # osetreni vyjimky - muze se stat, ze user neexistuje/nelze ho najit -> preskocit
        rescue
          next
        end
        
      end
    end
    
  end
  
end

# pocet ulozenych zaznamu s danym mappingem
def number_of_stored_documents(mapping)
  s = Tire.search 'github', :search_type => 'count' do
    query { term :_type, mapping }
  end
  s.results.total
end

# najdi id posledniho ulozeneho zaznamu v danem mappingu
def last_id(mapping)
  s = Tire.search 'github' do
    query { term :_type, mapping }
    facet 'max_id' do
      statistical :id
    end
  end
  s.results.facets['max_id']['max']
end

# funkce pro ziskani souradnic mista
def get_location(name)
  #country Bias - prefered countries
  #prefered_countries = ['US', 'GB', 'DE', 'CA', 'FR', 'SE', 'BR', 'IT'].join('+')
  # criteria for search on Geonames
  search_criteria = Geonames::ToponymSearchCriteria.new
  search_criteria.q = name.downcase.gsub(',','')
  #search_criteria.country_bias = prefered_countries
  search_criteria.username = 'USERNAME'
  search_criteria.password = 'PASSWORD'
  results = Geonames::WebService.search(search_criteria)
  # take first returned record, retrieve latitude and longitude
  first_record = results.toponyms[0]
  lat = first_record.latitude
  lon = first_record.longitude
  country = first_record.country_code
  name = first_record.name
  {:lat => lat, :lon => lon, :country => country, :name => name}
end

# take results of a Tire search and transform them to hash
# expects: results of search in Tire of class Tire::SEARCH:SEARCH
# designed to work with frequency table of words (number of users per country)
module Tire
  module Search
    class Search
      
      def results_to_hash
        hash = Hash.new()
        arr = self.results.facets["codes"]["terms"]
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