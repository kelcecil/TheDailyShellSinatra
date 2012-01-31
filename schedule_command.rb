#!/usr/bin/env ruby

require 'data_mapper'
require "#{Dir.pwd}/util/DataMapperHelpers"
require "#{Dir.pwd}/FeaturedInfo"
require 'mongo'

threshold = 30

# 1. Grab a count of the number of programs in MongoDB.
# 2. Generate 10 random
# 3. Get a list of 10 commands from MongoDB.
# 4. Iterate through the list and use the first one that isn't in the threshhold
# 5. Update the last used date adding the SQLite record if necessary.

def main()
  # 1. Open connections to the database
  mongodb_connection = open_mongo_connection()
  prepare_sql()

  random_number = Random.new
  satisfied = false

  # 2. Grab a count of the number of programs in MongoDB.
  count = mongodb_connection.collection('programs').count()

  # Loop until we're satisfied
  until satisfied do
    # 3. Generate a list of 10 ids for random programs
    random_progs = []
    (1..10).each do |num|
      random_progs.push(random_number.rand(1..count))
    end

    # 4. Iterate through the list and use the first one with a date outside the threshold
    random_progs.each do |indice|
      program = FeaturedInfo.get!(indice)
      if (Date.today - program.datelastfeatured).to_i > 30 then
        # Let's use this one!
        status = program.update(:datelastfeatured => Date.today)
        if status then
          satisfied = true
          break
        else
          next
        end
      else
        # Let's move on to the next.
        next
      end
    end
  end
end

def open_mongo_connection()
  return Mongo::Connection.new("localhost", 27017).db('thedailyshell');
end

def prepare_sql
  setup_db(:default,"sqlite://#{Dir.pwd}/db/dailyshell.db")
  finalize_db()
end

if __FILE__ == $0
  main()
end
