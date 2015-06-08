class Product < ActiveRecord::Base
  # attr_accessible :name, :price, :url

  validates :name, :presence => true
  validates :price, :presence => true
  validates :url, :presence => true

end
