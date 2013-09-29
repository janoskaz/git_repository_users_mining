require_relative 'github_crawler'


# autentizovat se
Octokit.configure do |c|
  c.login = 'username'
  c.password = 'password'
end

# delete database
#delete_database('github')

# if ElasticSearch is not running, will raise an exception and exit program
es_running?


# if tehre is no index called 'github', create it
unless database_exists?('github')
  db = create_database('github')
  puts 'creating new database'
  last_user = 0
  last_repo = 0
  
else
  # are there any users stored in the database?
  # if yes, get the id of last user
  nr_users = number_of_stored_documents('github','user')
  puts 'Database currently has ' + nr_users.to_s + ' users'
  if nr_users==0
    last_user = 0
  else
    last_user = last_id('github','user')
    puts 'Last user in the database has id ' + last_user.to_s
  end
  
  # are there any repositories stored in the database?
  # if yes, get the id of last repo
  nr_repos = number_of_stored_documents('github','repo')
  puts 'Database currently has ' + nr_repos.to_s + ' repos'
  if nr_repos==0
    last_repo = 0
  else
    last_repo = last_id('github','repo')
    puts 'Last repo in the database has id ' + last_repo.to_s
  end
end


# get pointer to database
db = Tire::Index.new('github')


# store users to database
Octokit.all_users_to_db(database = db, last_user = last_user, upper_limit = 2_000)

# store repositories and commits
Octokit.all_repos_to_db(database = db, last_repo = last_repo, upper_limit = 250_000)
