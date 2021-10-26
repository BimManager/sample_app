require 'rails_helper'
require 'factory_bot'

describe UsersController do
  render_views

  describe "Get 'new'" do
    it 'should have 200 status code' do
      get :new
      expect(response).to have_http_status(200)
    end

    it "should have a title containing 'Sign up'" do
      get :new
      expect(response.body).to match /<title>.*Sign up.*<\/title>/
    end

    it 'should have a name field' do
      get :new
      expect(response.body).to match /<input.*name="user\[name\]".*>/
    end

    it 'should have an email field' do
      get :new
      expect(response.body).to match /<input.*name="user\[email\]".*>/
    end

    it 'should have a password field' do
      get :new
      expect(response.body).to match /<input.*name="user\[password\]".*>/
    end

    it 'should have a password confirmation field' do
      get :new
      expect(response.body).to match \
      /<input.*name="user\[password_confirmation\]".*>/
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

  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr = { :name => '', :email => '', :password => '',
                  :password_confirmation => '' }
      end

      it 'should not create a user' do
        expect { post :create, :params => { :user => @attr } }.not_to \
        change(User, :count)
      end

      it 'should have the right title' do
        post :create, :params => { :user => @attr }
        expect(response.body).to have_title('Ruby on Rails Tutorial Sample ' \
                                            'App | Sign up')
      end

      it 'should render the "new" page' do
        post :create, :params => { :user => @attr }
        expect(response).to render_template('new')
      end
    end

    describe 'success' do
      before(:each) do
        @attr = { :name => 'New User',
                  :email => 'user@example.com',
                  :password => 'foobar',
                  :password_confirmation => 'foobar' }
      end
      
      it 'should create a new user' do
        expect { post :create,
                      :params => { :user => @attr } }.to \
                                                        change(User,
                                                               :count).by(1)
      end

      it 'should redirect to the user show page' do
        post :create, :params => { :user => @attr }
        expect(response).to redirect_to(user_path(assigns(:user)))
      end

      it 'should have a welcome message' do
        post :create, :params => { :user => @attr }
        expect(flash[:success]).to match(/welcome to the sample app/i)
      end
    end
  end
end
