class Profile < ActiveRecord::Base

  belongs_to :user

  has_one :contact_requirement
  has_many :experiences
  has_many :portfolio_items
  has_many :faqs

  attr_accessible :user_id, :education, :experience, :skills, :skill1, :skill2, :skill3, :view_profile,
                  :experiences_attributes, :image, :portfolio_items_attributes,
                  :faqs_attributes, :hometown, :contact_requirement_attributes

  accepts_nested_attributes_for :experiences, allow_destroy: true
  accepts_nested_attributes_for :portfolio_items, allow_destroy: true
  accepts_nested_attributes_for :faqs, allow_destroy: true
  accepts_nested_attributes_for :contact_requirement

  mount_uploader :image, ImageUploader

end
