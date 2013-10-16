git_repository_users_mining
===========================

mining information about users and repositories on github

User must be authenticated on github and also has an acount on geonames.org

Data about users, repositories and commits are crawled using github API, for aech user, a location is determined using geonames API and stored in elasticsearch database.
Determination of location uses following procedure:
- is there exact match of country? (i.e. user states *Germany* as his location)
- if not: is there exact match of city? (i.e. *San Francisco de Macorís*)
- if not: find biggest city, which matches the location (i.e. for *San Francisco*, it is San Francisco, California)



Description of files:
---------------------
- github_crawler.rb : functions, used by other files
- fill_database.rb : crawl github and store information in the database
- mine_information.rb : perform simple analysis and generate some charts
    - one file with maps (using google map charts) is generated. two maps are included: map of states and map of cities with numbers of github users
    - one file with word clouds is generates. one word cloud shows most frequent words in user bio description, second word cloud shows most frequent words in commits
    - two html files in directory high_chart are generated - graph of number of registered users in time, and graph of languages used in repos
- create_gexf_file.rb : find users, who frequently collaborate and vizualize them using sigma_js
    - uses apriori program to extract pairs of users
    - uses sigma_js to vizualize them
    - lib/gexf contains scripts to generate gexf file (graph with nodes and edges is created, xml file is produced)
    - examples/sigma_js contains files neccessary to vizualize the graph 

Pitfalls:
---------
- requires to have acount on both github and geonames
- searching for location for every user slows inserting the data significantly
- Determination of user location is approximate, includes mistakes (i.e. SL,UT is supposedly Salt Lake, Utah, but geonames return no result for this query)
- github allows only 5000 hits per user per hour
- Loading maps from Google map charts (map of cities) is very slow
- No updating mechanism so far

TODO:
-----
- sigma_js graph - width of edges proportional to *strength* of relation
- google map of cities: would be faster, if coordinates are available?
- custom analyzer for messages in commits and user biography?
- better organize the files
- clustering of documents in a database - some form of text mining. Perhaps use R?
- high chart graph generation should be reorganized. Currently there are only functions designed specificaly to generate one type of graph, without any possibility of inserting parameters

used gems: octokit, tire, curb, net/http, json