class Group < ActiveRecord::Base
  attr_accessible :concept, :name
  
  validates :name, presence: true
end
