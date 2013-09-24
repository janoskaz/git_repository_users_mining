git_repository_users_mining
===========================

mining information about users and repositories on github

User must be authenticated on github and also has an acount on geonames.org

Data about users, repositories and commits are crawled using github API, for aech user, a location is determined using geonames API and stored in elasticsearch database.



in ruby gem geodata, following changes must be made:

file web_service.rb
add following lines to function search (line 452)

url << "&countryBias="     + CGI.escape(search_criteria.country_bias)     unless search_criteria.country_bias.nil?

url << "&username="        + CGI.escape(search_criteria.username)         unless search_criteria.username.nil?

url << "&password="        + CGI.escape(search_criteria.password)         unless search_criteria.password.nil?


file toponym_search_criteria.rb
to attr_accessor add:
:username, :password, :country_bias


file crawl_github.rb just fills the database
file mine_user_information.rb generates js file with code to visualize the map of countries with corresponding numbers of users(map_chart.html)

WARNING: determination of location of users is so far insufficient, will be corrected
