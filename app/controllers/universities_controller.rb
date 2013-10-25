class UniversitiesController < ApplicationController

  def create_club
    @university = current_user.university
    @club = @university.clubs.new(params[:club])
    @club.user_id = current_user.id
    if @club.save
      @club.memberships.create(user_id: current_user.id, admin: true)
      redirect_to university_club_path(@university, @club)
    else
      load_details_data
      render :show
    end
  end

  def index
    @universities = University.all
  end

  def home
    @university = current_user.university
    load_details_data
    render :show
  end

  def show
    @university = University.find(params[:id])
    load_details_data
  end

  private
    def load_details_data
      @bg_style = "background-image: url('#{@university.banner.url}')" unless @university.banner.blank?
      @users = @university.users
      @updateable = @university
      @updates = @updateable.updates
      @free_food_events = @university.events.free_food
      @university_events = @university.events.all
      @update = Update.new
      @clubs = @university.clubs.order(:name)
      @club ||= @university.clubs.build
      @club_updates = Update.where(updateable_type: "Club").where(updateable_id: @clubs.map(&:id)).order("created_at DESC").all
    end
end
