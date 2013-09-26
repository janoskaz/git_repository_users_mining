git_repository_users_mining
===========================

mining information about users and repositories on github

User must be authenticated on github and also has an acount on geonames.org

Data about users, repositories and commits are crawled using github API, for aech user, a location is determined using geonames API and stored in elasticsearch database.




file crawl_github.rb just fills the database
file mine_user_information.rb generates js file with code to visualize the map of countries with corresponding numbers of users(map_chart.html)
also, map of USA with biggest cities as markers is plotted,however the loading is painfully slow

file also generates word cloud of most frequently used terms in user bio description
jQCloud is used for visualization (word_cloud.html)
requires jqcloud.css and jqcloud-1.0.4.js in directory word_cloud
both files can be obtained from: https://github.com/lucaong/jQCloud

WARNING: determination of location of users is so far insufficient, will be corrected

used gems: octokit, tire, curb, net/http, json