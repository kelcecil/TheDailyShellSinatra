require './service.rb'

def setup_db(context,url)
    begin
	DataMapper.setup(context,url)
    rescue => error
    	puts "setupDB :: #{error}"
    end
end

def finalize_db()
    begin
	DataMapper.finalize
    rescue
	puts "finalizeDB :: #{error}"
    end
end

configure do
	  url = "sqlite://#{Dir.pwd}/db/dailyshell.db"

	  # Set up connection pooling for Mongo DB queries
	  mongo = Mongo::Connection.new("localhost",27017, :pool_size => 10, :pool_timeout => 200).db('thedailyshell')

	  # Set up pooled connection for Relational queries using DataMapper
	  setup_db(:default,url)
	  finalize_db()
end

run TheDailyShell