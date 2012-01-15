#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require 'mongo'
require 'logger'
require 'haml'
require 'data_mapper'

require './FeaturedInfo'

set :static, true

class TheDailyShell < Sinatra::Application

  helpers do
    def get_todays_command_from_mongo(query)
      #return mongo.collection('programs').find_one(query)
    end

    def get_todays_command_uuid_from_sql()
      return FeaturedInfo.all(:order => [ :datelastfeatured.desc ], :limit => 1, :fields => [:uuid])
    end
    
    def render_a_command_by_name(name)
      haml :index, :locals => {:command => get_todays_command_from_mongo('name' => name)}
    end

    def render_a_command_by_uuid(uuid)
      # If the page comes back, render.
      haml :index, :locals => {:command => get_todays_command_from_mongo('uuid' => uuid)}
      # If no record is found, draw a 404.
    end
    
  end

  get '/' do
    # Grab most recent command id
    puts mongo
    render_a_command_by_uuid(get_todays_command_uuid_from_sql())
  end
  
  get '/#!/:name' do   
    # Sanitize and check for nonsense.

    # Render the page for the visitor.
    render_a_command_by_name(params[:name])
  end

  get '/about' do
    
  end
end
