class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :experiences
  has_many :portfolio_items

  attr_accessible :user_id, :education, :experience, :skills, :experiences_attributes, :image, :portfolio_items_attributes

  accepts_nested_attributes_for :experiences, allow_destroy: true
  accepts_nested_attributes_for :portfolio_items, allow_destroy: true

  mount_uploader :image, ImageUploader

end