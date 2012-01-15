class FeaturedInfo
  include DataMapper::Resource

  property :id, Serial
  property :uuid, String
  property :datelastfeatured, Date
end
