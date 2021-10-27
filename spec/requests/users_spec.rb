require 'rails_helper'

RSpec.describe "Users", type: :feature do
  describe 'signup' do
    describe 'failure' do
      it 'should not make a new user' do
        visit signup_path
        fill_in 'Name', with: ''
        fill_in 'Email', with: ''
        fill_in 'Password', with: ''
        fill_in 'Confirmation', with: ''
        click_button
        expect(page).to have_selector('div#error_explanation')
      end
    end

    describe 'success' do
      it 'should create a new user' do
        visit signup_path
        fill_in 'Name', with: 'Foo Bar'
        fill_in 'Email', with: 'foobar@gmail.com'
        fill_in 'Password', with: 'foobar'
        fill_in 'Confirmation', with: 'foobar'
        click_button
        expect(page).to have_content('Welcome to the Sample App!')
      end
    end
  end

  describe 'sign in/out' do
    describe 'failure' do
      it 'should not sign a user in' do
        visit signin_path
        fill_in 'Email', with: ''
        fill_in 'Password', with: ''
        click_button
        expect(page).to have_selector('div.flash.error', :text => 'Invalid')
      end
    end

    describe 'success' do
      it 'should sign a user in and out' do
        user = FactoryBot.create(:user)
        visit signin_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button
        #expect(controller.signed_in?).to eq(true)
        click_link 'Sign out'
        #expect(controller.signed_in?).to eq(false)
      end
    end
  end
end
