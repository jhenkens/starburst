module Starburst
  module AnnouncementsHelper
    def current_announcement
      unless @current_announcement
        current_user = (respond_to? Starburst.current_user_method) && send(Starburst.current_user_method)
        add_cookie_ids_to_user(current_user)
        @current_announcement ||= Announcement.current(current_user, cookies.signed[Starburst.cookie_identifier])
      end
      @current_announcement
    end

    private
    def add_cookie_ids_to_user(current_user = nil)
      current_user ||= (respond_to? Starburst.current_user_method) && send(Starburst.current_user_method)
      if current_user && (cookie_ids = cookies.signed[Starburst.cookie_identifier]) && cookie_ids.any?
        if AnnouncementView.create_for_user_and_ids(current_user, cookie_ids)
          cookies.delete(Starburst.cookie_identifier)
        end
      end
    end
  end
end
