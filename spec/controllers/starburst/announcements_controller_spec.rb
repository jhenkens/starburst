require 'spec_helper'

module Starburst

  describe AnnouncementsController do

    routes { Starburst::Engine.routes } # http://pivotallabs.com/writing-rails-engine-rspec-controller-tests/

    it "marks an announcement as read" do
      @current_user = mock_model(User, :id => 10)
      controller.stub(:current_user).and_return(@current_user)
      announcement = FactoryGirl.create(:announcement)
      post :mark_as_read, :id => announcement.id
      expect(response.status).to eq 200
      expect(AnnouncementView.last.user_id).to eq 10
      expect(AnnouncementView.all.length).to eq 1
    end

    it "marks an announcement as read via a cookie if no one is logged in" do
      controller.stub(:current_user).and_return(nil)
      announcement = FactoryGirl.create(:announcement)
      post :mark_as_read, :id => announcement.id
      expect(response.status).to eq 200
      expect(AnnouncementView.all.length).to eq 0
      expect(cookies.signed['starburst_hidden_announcement_ids']).to eq [announcement.id.to_s]
    end

    it "marking an announcement as read when a user has hidden announcements via cookie" do
      controller.stub(:current_user).and_return(nil)
      announcement = FactoryGirl.create(:announcement)
      post :mark_as_read, :id => announcement.id
      expect(response.status).to eq 200
      expect(AnnouncementView.all.length).to eq 0
      expect(cookies.signed['starburst_hidden_announcement_ids']).to eq [announcement.id.to_s]
      @current_user = mock_model(User, :id => 10)
      controller.stub(:current_user).and_return(@current_user)
      announcement2 = FactoryGirl.create(:announcement)
      post :mark_as_read, :id => announcement2.id
      expect(response.status).to eq 200
      expect(AnnouncementView.last.user_id).to eq 10
      expect(AnnouncementView.all.length).to eq 2
      expect(cookies.signed['starburst_hidden_announcement_ids']).to eq nil
    end

    it "has a helper path for mark as read" do
      expect(mark_as_read_path(1)).to eq "/starburst/announcements/1/mark_as_read"
    end

  end

end