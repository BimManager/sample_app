require 'rails_helper'
require 'factory_bot'

describe UsersController do
  render_views

  describe "Get 'new'" do
    it 'should have 200 status code' do
      get :new
      expect(response).to have_http_status(200)
    end

    it "should have a title containing 'Sing up'" do
      get :new
      expect(response.body).to match /<title>.*Sign up.*<\/title>/
    end
  end

  describe "Get 'show'" do
    before(:each) { @user = FactoryBot.create(:user) }

    it 'should be successful' do
      get :show, :params => { :id => @user.id }
      expect(response).to have_http_status(200)
    end

    it 'should find the right user' do
      get :show, :params => { :id => @user.id }
      expect(assigns(:user)).to eq(@user)
    end

    it 'should have the right title' do
      get :show, :params => { :id => @user.id }
      expect(response.body).to match(/#{@user.name}/)
    end

    it "should include the user's name" do
      get :show, :params => { :id => @user.id }
      expect(response.body).to match(/#{@user.name}/)
    end

    it 'should have a profile image' do
      get :show, :params => { :id => @user.id }
      #      expect(response.body).to match(/<img.+class="gravatar"/)
      expect(response.body).to have_selector 'h1>img', :class => 'gravatar'
    end
  end
end
