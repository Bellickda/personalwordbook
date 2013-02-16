class Account < ActiveRecord::Base
  attr_accessible :content, :title, :category, :priority, :url
  belongs_to :user

  validates :url, :title, :content, :category, :priority, presence: true
end