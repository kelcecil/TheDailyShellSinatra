#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require 'mongo'
require 'haml'
require 'data_mapper'

require './FeaturedInfo'

set :static, true

class TheDailyShell < Sinatra::Application

  helpers do
    def get_todays_command_from_mongo(query)
      return MongoDB.collection('programs').find_one(query)
    end

    def get_todays_command_uuid_from_sql()
      # Need to add some branch logic for ambiguous cases where commands share names.
      potential_commands = FeaturedInfo.all(:order => [ :datelastfeatured.desc ], :limit => 1, :fields => [:uuid])
      return potential_commands.first.uuid
    end
    
    def render_a_command_by_name(name)
      haml :command, :locals => {:command => get_todays_command_from_mongo('name' => name)}
    end

    def render_a_command_by_uuid(uuid)
      # If the page comes back, render.
      haml :command, :locals => {:command => get_todays_command_from_mongo('uuid' => uuid)}
      # If no record is found, draw a 404.
    end
    
  end

  get '/landing' do
    haml :landing
  end

  get '/' do
    # Grab most recent command id
    #render_a_command_by_uuid(get_todays_command_uuid_from_sql())
    haml :landing
  end
  
  get '/command/:name' do   
    # Sanitize and check for nonsense.

    # Render the page for the visitor.
    render_a_command_by_name(params[:name])
  end

  get '/about' do
    
  end
end
