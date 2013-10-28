class MetropolitanClubsController < ApplicationController
  def show
    @university = current_user.university
    @metropolitan_club = current_user.metropolitan_club
    redirect_to edit_user_profile_path(current_user, current_user.profile), notice: "please update your current city" unless @metropolitan_club
    @bg_style = "background-image: url('#{@metropolitan_club.image.url}')" unless current_user.university.banner.blank?
  end
end
