module Starburst
  class AnnouncementsController < ApplicationController
    include AnnouncementsHelper

    def mark_as_read
      announcement = Announcement.find(params[:id].to_i)
      if announcement
        if respond_to?(Starburst.current_user_method) && (current_user = send(Starburst.current_user_method))
          add_cookie_ids_to_user(current_user)
          if AnnouncementView.create(:user => current_user, :announcement => announcement)
            render :json => :ok
          else
            render json: nil, :status => :unprocessable_entity
          end
        else
          ids = [params[:id], *cookies.signed[:starburst_hidden_announcement_ids]]
          cookies.permanent.signed[:starburst_hidden_announcement_ids] = ids
          render :json => :ok
        end
      else
        render json: nil, :status => :unprocessable_entity
      end
    end
  end
end