require 'rails_helper'

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
    expect(page).to have_text(/Users#new/)
  end
end
