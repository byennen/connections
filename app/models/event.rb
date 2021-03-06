class Event < ActiveRecord::Base
  attr_accessible :title, :location, :description, :category,
                  :image, :free_food, :on_date, :at_time, :university_id, :club_id, :display_on_uc

  belongs_to :user
  belongs_to :university
  belongs_to :club

  has_many :interesteds, as: :interested_obj, dependent: :destroy

  mount_uploader :image, ImageUploader

  scope :free_food, where(free_food: true)
  scope :non_free_food, where(free_food: !true)
  scope :display_on_university_calendar, where(display_on_wc: true)
  scope :active, where("events.on_date >= ?", Date.today)
  scope :this_month, where("events.on_date >= ? AND events.on_date <= ?", Time.now, Time.now.end_of_month)
  scope :this_week, where("events.on_date >= ? AND events.on_date <= ?", Time.now, Time.now.end_of_week)
  scope :my_events, where("events.on_date >= ? AND events.on_date <= ?", Time.now, Time.now.end_of_year)

  validates :title, presence: true
  validates :on_date, presence: true

  after_create :add_club_update

  alias_attribute :name, :title

  default_scope order('on_date ASC')
  default_scope where("events.on_date >= ?", Time.now)

  def date
    on_date.strftime("%a %m.%d") if on_date
  end

  def time
    at_time.strftime("%I:%M %p") if at_time
  end

  class << self
    def by_month(str)
      date = Date.strptime(str,"%m%y")
      where("events.on_date >= ? AND events.on_date <= ?", date.beginning_of_month, date.end_of_month)
    end

    def search_all(params)
      return where("1=1") if params.blank?
      search_title(params[:title]).search_date(params[:on_date]).search_time(params[:time])
      .search_location(params[:location]).search_category(params[:category]).search_free_food(params[:free_food])
      .search_range(params[:start_date], params[:end_date])
    end

    def search_title(title)
      return where("1=1") if title.blank?
      where("lower(title) like ?", "%#{title.downcase}%")
    end

    def search_location(location)
      return where("1=1") if location.blank?
      where("lower(location) like ?", "%#{location.downcase}%")
    end

    def search_category(category)
      return where("1=1") if category.blank? || category == "All category"
      where("lower(category) like ?", "%#{category.downcase}%")
    end

    def search_date(date)
      return where("1=1") if date.blank?
      where(on_date: date)
    end

    def search_free_food(free)
      return where("1=1") if free.blank? || free=="All"
      free=='free' ? free_food : non_free_food
    end

    def search_time(range)
      return where("1=1") if range.blank? || range =="All"
      hmin = TIME_RANGE[range].first
      hmax = TIME_RANGE[range].last
      min=Time.strptime("2000/01/01 #{hmin}:00 UTC","%Y/%m/%d %H:%M %Z")
      max=Time.strptime("2000/01/01 #{hmax}:59 UTC","%Y/%m/%d %H:%M %Z")
      where("at_time >= ? and at_time <= ?", min, max)
    end

    def search_range(start_date, end_date)
      return where("1=1") if start_date.blank? && end_date.blank?
      result = where("events.on_date >= ?", start_date) unless start_date.blank?
      result = result.where("events.on_date <= ?", end_date) unless end_date.blank?
      result
    end

  end

  TIME_RANGE = {"0 - 2 AM" => [0,2], "2 - 4 AM" => [2,4], "4 - 6 AM" => [4,6], "6 - 8 AM" => [6,8], "8 - 10 AM" => [8,10], "10AM - 12 PM" => [10,12],
     "12 - 2 PM" => [12,14], "2 - 4 PM" => [14,16], "4 - 6 PM" => [16,18], "6 - 8 PM" => [18,20], "8 - 10 PM" => [20, 22], "10 - 0 AM" => [22,24]}

  private
    def add_club_update
      if club
        update=club.updates.new(headline: title, body: description)
        update.image = image.file unless image.blank?
        update.save
      end
    end
end
