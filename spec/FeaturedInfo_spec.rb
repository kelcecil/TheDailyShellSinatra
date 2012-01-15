require 'rspec'
require 'data_mapper'
require './FeaturedInfo.rb'
require './util/DataMapperHelpers.rb'
require 'date'

describe FeaturedInfo do

  before :all do
    setup_db(:default,"sqlite://#{Dir.pwd}/db/testfeaturedinfo.db")
    finalize_db()
    migrate_db()
    
    begin
      @creation = FeaturedInfo.create(:uuid => 'test', :datelastfeatured => Date.today)
    rescue => error
      puts "before:: #{error}"
    end      
  end

  describe 'Writing a new record to the DB' do
    it 'should have saved the example to the database' do
      @creation.saved?.should be true
    end
  end

  describe 'Reading from the DB' do
    
    before(:all) do
      @read_item = FeaturedInfo.get(@creation.id)
    end
    
    it 'can read the uuid' do
      @read_item.uuid.should == 'test'
    end

    it 'can read the last featured date' do
      @read_item.datelastfeatured.should == Date.today
    end
  
  end

  after(:all) do
    # Clean up our SQLite fun.
    File.delete("#{Dir.pwd}/db/testfeaturedinfo.db")
  end


end
