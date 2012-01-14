#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require 'mongo'
require 'logger'
require 'haml'

set :static, true

class TheDailyShell < Sinatra::Application

  helpers do
    def get_todays_command_from_mongo(id)
      return MongoDB.collection('programs').find_one('name' => "w")
    end

    def get_todays_command_id_from_sql()
      
    end
  end


  get '/' do   

    haml :index, :locals => {:command => get_todays_command_from_mongo(1)}

  end
end
