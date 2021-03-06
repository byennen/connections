class Club < ActiveRecord::Base
  belongs_to :university

  has_many :memberships, dependent: :destroy
  has_many :users, :through => :memberships, :uniq => true
  has_many :albums, dependent: :destroy
  has_many :club_photos, through: :albums
  has_many :events, dependent: :destroy
  has_many :statuses, dependent: :destroy # this is lowdowns here
  has_many :records, dependent: :destroy
  has_many :updates, as: :updateable, dependent: :destroy
  has_many :leaders, through: :memberships, source: :user, conditions: {"memberships.admin" => true}
  has_many :posts, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :transactions, dependent: :destroy

  has_one :stripe_credential, as: :owner, dependent: :destroy
  belongs_to :user

  attr_accessible :category, :description, :name, :university_id, :image,
                  :remote_image_url, :user_id, :slug, :private, :mission_statement

  validates :name, presence: true
  validates :university_id, presence: true
  validates :user_id, presence: true
  validates :image, presence: true, on: :create
  
  scope :sup_club, where(type: nil)
  scope :privates, where(:private => true)
  scope :publics, where("clubs.private is null or clubs.private=false")
  CATEGORIES = [
    "Academic",
    "Alumni",
    "Arts",
    "Social",
    "Gender",
    "Health",
    "Media",
    "Performance",
    "Political",
    "Recreational",
    "Sports",
    "Religious",
    "Service",
    "Student Govt",
    "Union Board"
  ]
  mount_uploader :image, ImageUploader

  acts_as_messageable
  
  extend FriendlyId
  friendly_id :name, use: :slugged

  before_save :default_category


  def admins
    @admins ||= memberships.where(admin: true).all.map(&:user)
  end

  def members
    users
  end

  def non_leaders
    ids = users.with_role(:super_admin).map(&:id).to_a + users.with_role(:university_admin).map(&:id).to_a
    mems = users
    mems = users.where("users.id not in (?)", ids) unless ids.blank?
    return mems if leaders.blank?
    mems.where("users.id not in (?)", leaders.map(&:id))
  end

  def default_category
    self.category = 'Alumni' unless category.present? || type != 'MetropolitanClub'
    true
  end


  class << self
    def search_all(params)
      search_name(params[:name]).search_category(params[:category]).search_private(params[:private])
    end
    def search_name(name)
      return where("1=1") if name.blank?
      where("lower(name) like ?", "%#{name.downcase}%")
    end

    def search_category(category)
      category_filter = where("1=1")
      return category_filter if (category.blank? || category == "All categories")
      if category != "Alumni"
        category_filter = category_filter.sup_club
      end
      category_filter.where("category=?", category)
    end

    def search_private(priv)
      return where("1=1") if priv.blank?
      priv=="true" ? privates : publics    
    end

  end
end
