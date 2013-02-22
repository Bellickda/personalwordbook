class Group < ActiveRecord::Base
  attr_accessible :concept, :name, :members
  serialize :members
  
  validates :name, presence: true
end
