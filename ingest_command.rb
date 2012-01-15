#!/usr/bin/env ruby

require 'mongo'
require 'data_mapper'
require 'json'
require 'uuid'
require './FeaturedInfo'

def main()

  uuid = UUID.new

  # Read and validate the text file containing the JSON object
  begin
    file = File.open(ARGV[0], 'rb')
  rescue
    return
  end
  file_contents = file.read
  
  # Open connections to the databases
  begin
    mongodb_connection = open_mongo_connection()
    prepare_sql()
  rescue => error
    return
  end
    
  # Generate a UUID to link the two databases.
  uuid = uuid.generate

  # Parse the JSON into an associative array and add the uuid
  program = JSON.parse(file_contents)
  program['uuid'] = uuid

  # Write new data to both databases
  mongodb_connection.collection("programs").insert(program)
  FeaturedInfo.create(:uuid => uuid, :datelastfeatured => Date.today - 32)

end

def open_mongo_connection()
  return Mongo::Connection.new("localhost", 27017).db('thedailyshell');
end

def prepare_sql
  setup_db(:default,"sqlite://#{Dir.pwd}/db/dailyshell.db")
  finalize_db()
end

def setup_db(context,url)
    begin
        DataMapper.setup(context,url)
    rescue => error
      puts "setupDB :: #{error}"
    end
end

def finalize_db()
    begin
      DataMapper.auto_upgrade!
      DataMapper.finalize
    rescue
      puts "finalizeDB :: #{error}"
    end
end

if __FILE__ == $0 then
  main()
end
