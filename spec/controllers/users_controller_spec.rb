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

  describe 'GET edit' do
    before(:each) do
      @user = FactoryBot.create(:user)
      test_sign_in(@user)
    end

    it 'should be successful' do
      get :edit, :params => { :id => @user }
      expect(response).to have_http_status(200)
    end

    it 'should have the right title' do
      get :edit, :params => { :id => @user }
      expect(response.body).to have_title('Ruby on Rails Tutorial Sample ' \
                                            'App | Edit user')
    end

    it 'should have a linkg to change the Gravatar' do
      get :edit, :params => { :id => @user }
      gravatar_url = 'https://gravatar.com/emails'
      expect(response.body).to have_selector(:css, "a[href=\"#{gravatar_url}\"]")
    end
  end

  describe 'GET index' do
    describe 'for non-signed-in users' do
      it 'should deny access' do
        get :index
        expect(response).to redirect_to(signin_path)
        expect(flash[:notice]).to match(/sign in/i)
      end
    end

    describe 'for signed-in users' do
      before(:each) do
        @user = FactoryBot.create(:user)
        test_sign_in(@user)
        second = FactoryBot.create(:user, :email => 'another@example.com')
        third = FactoryBot.create(:user, :email => 'another@example.net')
        @users = [@user, second, third]
        30.times do
          @users << FactoryBot.create(:user, :email => FactoryBot.generate(:email))
        end
      end

      it 'should be successful' do
        get :index
        expect(response).to have_http_status(200)
      end

      it 'should have the right title' do
        get :index
        expect(response.body).to have_title('Ruby on Rails Tutorial Sample ' \
                                            'App | All users')
      end

      it 'should have an element for each user' do
        get :index
        @users[0..2].each do |user|
          expect(response.body).to have_css('li', text: user.name)
        end
      end

      it 'should paginate users' do
        get :index
        expect(response.body).to have_selector('div.pagination')
        expect(response.body).to have_selector(
                                   'span.disabled', text: 'Previous')
        expect(response.body).to have_selector(:css,
                                                'a[href="/users?page=2"]')
      end
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

      it 'should sign the user in' do
        post :create, :params => { :user => @attr }
        expect(controller.signed_in?).to eq(true)
      end
    end
  end

  describe 'PUT update' do
    before(:each) do
      @user = FactoryBot.create(:user)
      test_sign_in(@user)
    end
    
    describe 'failure' do
      before(:each) do
        @attr = empty_attr        
      end

      it 'should render the edit page' do
        put :update, :params => { :id => @user, :user => @attr }
        expect(response).to render_template('edit')
      end

      it 'should have the right title' do
        put :update, :params => { :id => @user, :user => @attr }
        expect(response.body).to have_title('Ruby on Rails Tutorial Sample ' \
                                            'App | Edit user')
      end
    end

    describe 'success' do
      before(:each) do
        @attr = { :name => 'New Name', :email => 'user@example.com',
                  :password => 'barbaz',
                  :password_confirmation => 'barbaz' }
      end

      it 'should change the attributes of the user' do
        put :update, :params => { :id => @user, :user => @attr }
        @user.reload
        expect(@user.name).to eq(@attr[:name])
        expect(@user.email).to eq(@attr[:email])
      end

      it 'should redirect to the user show page' do
        put :update, :params => { :id => @user, :user => @attr }
        expect(response).to redirect_to(user_path(@user))
      end

      it 'should have a flash message' do
        put :update, :params => { :id => @user, :user => @attr }
        expect(flash[:success]).to match(/updated/)
      end
      
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      @user = FactoryBot.create(:user)
    end

    describe 'as a non-signed-in user' do
      it 'should deny access' do
        delete :destroy, :params => { :id => @user }
        expect(response).to redirect_to(signin_path)
      end
    end

    describe 'as a non-admin user' do
      it 'should protect the page' do
        test_sign_in(@user)
        delete :destroy, :params => { :id => @user }
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'as an admin user' do
      before(:each) do
        admin = FactoryBot.create(:user, :email => 'admin@example.com',
                                  :admin => true)
        test_sign_in(admin)
      end

      it 'should destroy the user' do
        expect { delete :destroy, :params => { :id => @user } }.to \
        change(User, :count).by(-1)
      end
    end
  end

  describe 'authentication of edit/update pages' do
    before(:each) do
      @user = FactoryBot.create(:user)
    end

    describe 'for non-signed-in users' do
      it 'should deny access to edit' do
        get :edit, :params => { :id => @user }
        expect(response).to redirect_to(signin_path)
      end

      it 'should deny access to update' do
        get :update, :params => { :id => @user, :user => {} }
        expect(response).to redirect_to(signin_path)
      end
    end

    describe 'for signed-in users' do
      before(:each) do
        wrong_user = FactoryBot.create(:user, :email => 'user@example.net')
        test_sign_in(wrong_user)
#        wrong_user.email = 'user@example.net'
      end

      it 'should require matching users for edit' do
        get :edit, :params => { :id => @user }
        expect(response).to redirect_to(root_path)
      end

      it 'should require matching user for update' do
        get :update, :params => { :id => @user, :user => {} }
        expect(response).to redirect_to(root_path)
      end
      
    end
    
  end  
end
