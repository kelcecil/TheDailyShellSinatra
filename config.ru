require './service.rb'

configure do
	  require 'mongo'
	  #context = :default
	  #URI = "sqlite://#{Dir.pwd}/db/dailyshell.db"

	  # Set up connection pooling for Mongo DB queries
	  MongoDB = Mongo::Connection.new("localhost",27017, :pool_size => 10, :pool_timeout => 200).db('thedailyshell')

	  # Load data structures we need for DataMapper ORM
	  
	  # Set up pooled connection for Relational queries using DataMapper
	  #setup_db(context,URI)
	  #finalize_db()
end

run TheDailyShell