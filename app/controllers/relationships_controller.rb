class RelationshipsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_relationship, except: [:create]

  rescue_from ActionController::RedirectBackError, with: lambda {redirect_to user_path(current_user)}

  def create
    @relationship = User.find(params[:relationship][:relation_id])
    Relationship.request(current_user, @relationship, params[:relationship][:message])
    respond_to do |format|
      format.html { redirect_to :back, notice: "A request has been sent to #{@relationship.name}" }
    end
  end

  def read
    respond_to do |format|
      format.js { }
    end
  end

  def accept
    @relationship.accept!
    Alert.create_relationship_notification(@relationship)
    respond_to do |format|
      format.html { redirect_to :back, notice: "You are now contacts with - #{@relationship.relation.name}" }
    end
  end

  def decline
    @relationship.decline!
    respond_to do |format|
      format.html { redirect_to :back, notice: "You have declined the contact - #{@relationship.relation.name}" }
    end
  end

  def refer
    Rails.logger.debug("@relationship is #{@relationship.inspect}")
    slugs = params[:relation_ids].split(",")
    refer_users = User.where(slug: slugs)
    refer_users.each do |user|
      @relationship.recommend!(user)
      Rails.logger.debug("refer relationship is #{user.inspect}")
    end
    @relationship.decline!
    respond_to do |format|
      format.html { redirect_to :back, notice: "You have referred - #{refer_users.count} contact#{'s' if refer_users.count != 1}" }
    end
  end

  def destroy
    @relationship.remove!
    respond_to do |format|
      format.html { redirect_to :back, notice: "You have removed the contact - #{@relationship.relation.name}" }
    end
  end

  def accept_recommendation
    @relationship.accept_recommendation!
    respond_to do |format|
      format.html { redirect_to :back, notice: "You have accepted the recommendation to #{@relationship.relation.name}" }
    end
  end

  def decline_recommendation
    @relationship.decline_recommendation!
    respond_to do |format|
      format.html { redirect_to :back, notice: "You have declined the recommendation to #{@relationship.relation.name}" }
    end
  end

  private

  def find_relationship
    @relationship = Relationship.find(params[:id])
  end

end
