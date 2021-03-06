#!/usr/bin/env ruby

require 'oauth'
require 'data_mapper'
require "#{File.expand_path(File.dirname(__FILE__))}/FeaturedInfo"
require "#{File.expand_path(File.dirname(__FILE__))}/util/DataMapperHelpers"
require 'mongo'
require 'uri'
require 'syslog'

CONSUMER_KEY = ''
CONSUMER_SECRET = ''

ACCESS_TOKEN = ''
ACCESS_TOKEN_SECRET = ''

BASE_TWITTER_API = 'http://api.twitter.com'

REQUEST_TOKEN_URL = 'https://api.twitter.com/oauth/request_token'
AUTHORIZE_URL = 'https://api.twitter.com/oauth/authorize'
ACCESS_TOKEN_URL = 'https://api.twitter.com/oauth/access_token'

STATUS_UPDATE = '/1/statuses/update.json'

def main()

  # 1. Establish a connection to Twitter and prepare to OAuth
  consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {:site => BASE_TWITTER_API})
  access_token = OAuth::AccessToken.new(consumer, ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

  # 2. Establish connections to the databases to read from Mongo and SQL
  begin
    mongo_connection = open_mongo_connection()
    prepare_sql()
  rescue Exception => error
    Syslog.open($0, Syslog::LOG_PID | Syslog::LOG_CONS) { |s| s.err error.message }
    return
  end

  # 3. Get the latest command from SQLite
  potential_commands = FeaturedInfo.all(:order => [ :datelastfeatured.desc], :limit => 1, :fields => [:uuid])
  
  # 4. Get the command entry from Mongo.
  command = mongo_connection.collection('programs').find_one('uuid' => potential_commands.first.uuid)

  # 5. Post the entry to Twitter @dailyshell
  access_token.post(URI.escape("#{STATUS_UPDATE}?status=#{command['name']} - http://www.thedailyshell.com/command/#{command['name']}"))

end

def open_mongo_connection()
  return Mongo::Connection.new("localhost", 27017).db('thedailyshell');
end

def prepare_sql
  setup_db(:default,"sqlite://#{File.expand_path(File.dirname(__FILE__))}/db/dailyshell.db")
  finalize_db()
end

if __FILE__ == $0
  main()
end
