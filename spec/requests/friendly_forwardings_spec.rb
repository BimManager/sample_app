require 'rails_helper'
require 'factory_bot'

RSpec.feature "FriendlyForwardings", type: :feature do
  feature "GET /friendly_forwardings" do
    scenario 'should forward to the requested page after signin' do
      user = FactoryBot.create(:user)
      visit edit_user_path(user)
      fill_in 'Email', :with => user.email
      fill_in 'Password', :with => user.password
      click_button
      expect(page).to have_text('Edit user')
    end
  end
end
