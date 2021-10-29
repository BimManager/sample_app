require 'rails_helper'
require 'factory_bot'

RSpec.feature 'LayoutLinks', type: :feature do
  scenario "User clicks the 'About' link" do
    visit root_path
    click_link 'About'
    expect(page).to have_text(/About/)
  end

  scenario "User clicks the 'Help' link" do
    visit root_path
    click_link 'Help'
    expect(page).to have_text(/Help/)
  end

  scenario "User clicks the 'Contact' link" do
    visit root_path
    click_link 'Contact'
    expect(page).to have_text(/Contact/)
  end

  scenario "User clicks the 'Home' link" do
    visit root_path
    click_link 'Home'
    expect(page).to have_text(/This is the home page for/)
  end

  scenario "User clicks the 'Sign up now!' link" do
    visit root_path
    click_link 'Sign up now!'
    expect(page).to have_text(/Sign up/)
  end

  scenario 'when the user is not signed in' do
    @user = FactoryBot.create(:user)
    visit signin_path
    expect(page).to have_css('a', text: 'Sign in')
  end

  feature 'when the user is signed in' do
    background(:each) do
      @user = FactoryBot.create(:user)
      visit signin_path
      fill_in 'Email', :with => @user.email
      fill_in 'Password', :with => @user.password
      click_button
    end
    
    scenario 'there should be a signout link' do
      visit root_path
      expect(page).to have_css('a', text: 'Sign out')
    end

    scenario 'there should be a profile link' do
      visit root_path
      expect(page).to have_css('a', text: 'Profile')
    end

    scenario 'they cannot see the delete link unless an admin' do
      visit users_path
      expect(page).not_to have_text('delete')
    end

    scenario 'they should be able to see the delete link if an admin' do
      admin = FactoryBot.create(:user, :email => 'admin@example.com',
                                :admin => true)
      visit signin_path
      fill_in 'Email', :with => admin.email
      fill_in 'Password', :with => admin.password
      click_button
      visit users_path
      expect(page).to have_text('delete')
    end
  end
end
