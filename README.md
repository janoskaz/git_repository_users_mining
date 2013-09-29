git_repository_users_mining
===========================

mining information about users and repositories on github

User must be authenticated on github and also has an acount on geonames.org

Data about users, repositories and commits are crawled using github API, for aech user, a location is determined using geonames API and stored in elasticsearch database.
Determination of location uses following procedure:
1) is there exact match of country? (i.e. user states "Germany" as his location)
2) if not: is there exact match of city? (i.e. "San Francisco de Macorís")
3) if not: find biggest city, which matches the location (i.e. for "San Francisco", it is San Francisco, California)



Description of files:
github_crawler.rb : functions, used by other files
fill_database.rb : crawl github and store information in the database
mine_information.rb : perform simple analysis and generate some charts
1) one file with maps (using google map charts) is generated. two maps are included: map of states and map of cities with numbers of github users
2) one file with word clouds is generates. one word cloud shows most frequent words in user bio description, second word cloud shows most frequent words in commits


Pitfalls:
requires to have acount on both github and geonames
searching for location for every user slows inserting the data significantly
Determination of user location is approximate, includes mistakes (i.e. SL,UT is supposedly Salt Lake, Utah, but geonames return no result for this query)
github allows only 5000 hits per user per hour
Loading maps from Google map charts (map of cities) is very slow
No updating mechanism so far


used gems: octokit, tire, curb, net/http, json