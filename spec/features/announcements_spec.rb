require 'spec_helper'

feature 'Announcements' do
  scenario 'show announcement to user' do
    #@user = FactoryGirl.create(:user)
    #login_as(@user, :scope => :user, :run_callbacks => false)
    @current_user = FactoryGirl.create(:user)
    ActionController::Base.any_instance.stub(:current_user).and_return(@current_user)
    ActionView::Base.any_instance.stub(:current_user).and_return(@current_user)
    announcement = FactoryGirl.create(:announcement, :body => "My announcement")
    visit root_path
    page.should have_content "My announcement"
  end
  scenario 'show announcements if user not logged in', js: true do
    ActionController::Base.any_instance.stub(:current_user).and_return(nil)
    ActionView::Base.any_instance.stub(:current_user).and_return(nil)
    announcement = FactoryGirl.create(:announcement, :body => "My announcement")
    visit root_path
    page.should have_content "My announcement"
    page.should have_content "Sample homepage"
  end
  scenario 'mark announcement as read then hide it from now on', js: true do
    @user = FactoryGirl.create(:user)
    ActionView::Base.any_instance.stub(:current_user).and_return(@user)
    ActionController::Base.any_instance.stub(:current_user).and_return(@user)
    announcement = FactoryGirl.create(:announcement, :body => "My announcement")
    visit root_path
    page.should have_content "My announcement"
    click_button "starburst-close"
    visit root_path
    page.should_not have_content "My announcement"
  end

  scenario 'mark announcement as read then hide it from now on if a user is not logged in', js: true do
    announcement = FactoryGirl.create(:announcement, :body => "My announcement")
    visit root_path
    page.should have_content "My announcement"
    click_button "starburst-close"
    visit root_path
    page.should_not have_content "My announcement"
  end
end