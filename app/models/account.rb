class Account < ActiveRecord::Base
  attr_accessible :content, :title, :category, :priority, :url, :tmp
  has_many :comment
  belongs_to :user

  validates :url, :title, :category, :priority, presence: true
end