require 'rails_helper'

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
end
