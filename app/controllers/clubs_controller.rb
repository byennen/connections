class ClubsController < ApplicationController

  before_filter :authenticate_user!, except: [:show]
  before_filter :ensure_user_university, except: [:show, :join, :search_members, :send_message, :message_to_club, :auto_search, :upload_photo]

  def search
    @clubs = @university.clubs.sup_club.search_all(params[:club])
    respond_to :js
  end

  def search_members
    @club = Club.find params[:id]
    users = @club.members.search_name(params[:term])
    return_auto_json(users)
  end

  def send_message
    @club = Club.find params[:id]
    @club.send_message(recipients, params[:message][:body], "message from #{@club.name} club", true, params[:message][:attachment])
    redirect_to redirect_path, notice: "Message sent!"
  end

  def message_to_club
    @club = Club.find params[:id]
    @subject = params[:message][:subject].blank? ? "message to #{@club.name} club" : params[:message][:subject]
    current_user.send_message(@club, params[:message][:body], @subject, true, params[:message][:attachment])
    redirect_to redirect_path, notice: "Message sent!"
  end

  def index
    @clubs = @university.clubs.sup_club
    @club = Club.new
  end

  def show
    @university = University.find(params[:university_id])
    @club = @university.clubs.find_by_slug(params[:id])
    @updateable = @club
    if @club
      @posts = @club.posts.order("created_at desc")
      @my_photos = @club.club_photos.by_user(current_user)
      @membership = Membership.new
      @members = @club.users
      @memberships = @club.memberships
      @current_membership = @club.memberships.find_by_user_id(current_user.id)
      @admins = @club.memberships.where(admin: true)
      if current_user.manage_club?(@club)
        @conversations = @club.mailbox.inbox
        @sentbox = @club.mailbox.sentbox
      else
        @conversations = current_user.conversations_for(@club)
        @sentbox = current_user.sent_to(@club)
      end
      @requests = current_user.relationships.where(status: 'pending')
      @invitation = Invitation.new
      @event = Event.new
      Rails.logger.debug("non admins are #{@non_admins.inspect}")
    else
      redirect_to root_path, alert: "Club not found"
    end
  end

  def new
    @club = @university.clubs.new
  end

  def create
    @clubs = @university.clubs.sup_club
    @club = @university.clubs.new(params[:club])
    @club.user_id = current_user.id
    if @club.save
      @club.memberships.create(user_id: current_user.id, admin: true)
      redirect_to action: :index
    else
      flash[:error] = 'Error creating club with invalid or missing information'
      render :index
    end
  end

  def edit
    @club = @university.clubs.find(params[:id])
  end

  def join
    club = Club.find params[:id]
    current_user.clubs << club
    redirect_to university_club_path(club.university, club), notice: "welcome to #{club.name} club"
  end

  def update
    @club = @university.clubs.find(params[:id])
    @club.attributes = params[:club]
    if @club.save
      respond_to do |format|
        format.html { redirect_to university_club_path(@university, @club) }
      end
    end
  end

  def transfer_ownership
    @club = @university.clubs.find(params[:id])
    @user = User.find(@club.user_id)
    @membership = @club.memberships.find_by_user_id(@user.id)
    @membership.admin = false
    @new_owner = User.find(params[:club][:user_id])
    @club.user_id = params[:club][:user_id]
    if @membership.save && @club.save
      respond_to do |format|
        format.html { redirect_to university_club_path(@university, @club), notice: "Ownership transferred to #{@new_owner.name}" }
      end
    end
  end
  
  def auto_search
    if current_user.super_admin?
      clubs = Club.where("lower(name) like ?", "%#{params[:term].downcase}%")
    else
      clubs = current_user.university.clubs.where("lower(name) like ?", "%#{params[:term].downcase}%")
    end
    return_auto_json(clubs)
  end

  def upload_photo
    @club = Club.find params[:id]
    photo = @club.club_photos.build(params[:club_photo])
    photo.user = current_user
    if photo.save
      redirect_to university_club_path(@club.university, @club), notice: "Upload photo successfully"
    else
      redirect_to university_club_path(@club.university, @club), error: photo.errors.full_messages.join(", ")
    end
  end

  private

    def ensure_user_university
      @university = University.find(params[:university_id])
      unless current_user.university == @university
        redirect_to university_path(params[:university_id])
      else
        return true
      end
    end

    def recipients
      mems = @club.members
      results = []
      results |= mems.student if params[:student]
      results |= mems.alumni if params[:alumni]
      results |= @club.leaders if params[:leader]
      slugs = params[:message][:recipients].split(',') if params[:message][:recipients]
      results |= User.where(slug: slugs).all unless slugs.blank?
      results
    end

    def redirect_path
      @club.instance_of?(Club) ? university_club_path(@club.university, @club) : metropolitan_club_path(@club)
    end
end
