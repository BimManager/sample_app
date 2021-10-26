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
#        expect(page).to render_template('users/new')
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
end
