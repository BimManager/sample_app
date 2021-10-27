require 'rails_helper'
require 'factory_bot'

describe SessionsController do
  render_views

  describe 'GET new' do
    it 'should return 200 status code' do
      get :new
      expect(response).to have_http_status(200)
    end

    it 'should have the right title' do
      get :new
      expect(response.body).to match(/<title>.*Sign in.*<\/title>/)
    end
  end

  describe 'POST create' do
    describe 'invalid signin' do
      before(:each) do
        @attr = { :email => 'email@example.com',
                  :password => 'invalid' }
      end

      it 'should re-render the new page' do
        post :create, :params => { :session => @attr }
        expect(response).to render_template(:new)
      end

      it 'should have the right title' do
        post :create, :params => { :session => @attr }
        expect(response.body).to match(/<title>.*Sign in.*<\/title>/)
      end

      it 'should have a flash.now message' do
        post :create, :params => { :session => @attr }
        expect(flash.now[:error]).to match(/invalid/i)
      end
    end

    describe 'with valid email and password' do
      before(:each) do
        @user = FactoryBot.create(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end

      it 'should sign the user in' do
        post :create, :params => { :session => @attr }
        expect(controller.current_user).to eq(@user)
        expect(controller.signed_in?).to eq(true)
      end

      it 'should redirect the user to the user show page' do
        post :create, :params => { :session => @attr }
        expect(response).to redirect_to(user_path(@user))
      end
    end
  end

  describe 'DELETE destroy' do
    it 'should sign a user out' do
      test_sign_in(FactoryBot.create(:user))
      delete :destroy
      expect(controller.signed_in?).to eq(false)
      expect(response).to redirect_to(root_path)
    end
  end
  
end
