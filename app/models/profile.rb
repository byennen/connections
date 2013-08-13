class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :experiences

  attr_accessible :user_id, :education, :experience, :skills, :experiences_attributes, :image

  accepts_nested_attributes_for :experiences, allow_destroy: true

  mount_uploader :image, ImageUploader
end
