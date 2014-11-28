module Starburst
  class AnnouncementView < ActiveRecord::Base
    if Rails::VERSION::MAJOR < 4
      attr_accessible :announcement, :user
    end
    belongs_to :announcement
    belongs_to :user
    validates_uniqueness_of :user_id, scope: :announcement_id

    def self.create_for_user_and_ids(user, ids)
      if ids && ids.any?
        ids = Announcement.where(id: ids).pluck(:id)
        ids.each do |id|
          first_or_create(user: user, announcement_id: id)
        end
      end
    end
  end
end