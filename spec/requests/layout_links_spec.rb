require 'rails_helper'

RSpec.describe 'LayoutLinks', type: :request do
  describe 'LayoutLinks' do
    it 'should have a Home page at /' do
      get '/'
      expect(response).to have_http_status(200)
      expect(response.body).to match /Home/
    end

    it 'should have a Contact page at /contact' do
      get '/contact'
      expect(response).to have_http_status(200)
      expect(response.body).to match /Contact/
    end

    it 'should have an About page at /about' do
      get '/about'
      expect(response).to have_http_status(200)
      expect(response.body).to match /About/
    end

    it 'should have a Help page at /help' do
      get '/help'
      expect(response).to have_http_status(200)
      expect(response.body).to match /Help/
    end

    it 'should have a signup page at /signup' do
      get '/signup'
      expect(response).to have_http_status(200)
      expect(response.body).to match /Sign up/
    end
  end
end
