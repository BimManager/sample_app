require 'rails_helper'

describe PagesController do
  render_views

  before(:each) { @base_title = %q[<title>Ruby on Rails Tutorial] }

  describe "GET 'home'" do
    it 'should have ok status' do
      get :home
      expect(response).to have_http_status(:ok)
    end

    it 'should have the right title' do
      get :home
      expect(response.body).to match /#{@base_title} | Home/
    end
  end

  describe "Get 'contact'" do
    it 'should have response code 200' do
      get :contact
      expect(response.status).to eq(200)
    end

    it 'should have the right title' do
      get :contact
      expect(response.body).to match /#{@base_title} | Contact/
    end
  end

  describe "Get 'about'" do
    it 'should have response code 200' do
      get :about
      expect(response.status).to eq(200)
    end

    it 'should have the right title' do
      get :about
      expect(response.body).to match /#{@base_title} | About/
    end
  end

  describe "Get 'help'" do
    it 'should have response code 200' do
      get :help
      expect(response.status).to eq(200)
    end

    it 'should have the right title' do
      get :help
      expect(response.body).to match /#{@base_title} | Help/
    end
  end
end
