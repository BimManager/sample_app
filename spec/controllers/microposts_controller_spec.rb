require 'rails_helper'
require 'factory_bot'

describe MicropostsController do
  render_views

  describe 'access control' do
    it 'should deny access to create' do
      post :create
      expect(response).to redirect_to(signin_path)
    end

    it 'should deny access to destroy' do
      delete :destroy, :params => { :id => 1 }
      expect(response).to redirect_to(signin_path)
    end
  end

  describe 'POST create' do
    before(:each) do
      @user = FactoryBot.create(:user)
      test_sign_in(@user)
    end

    describe 'failure' do
      before(:each) { @attr = { :content => '' } }

      it 'should not create a micropost' do
        expect { post :create, :params => { :micropost => @attr } }.not_to \
        change(Micropost, :count)
      end

      it 'should render the home page' do
        post :create, :params => { :micropost => @attr }
        expect(response).to render_template('pages/home')
      end
    end

    describe 'success' do
      before(:each) { @attr = { :content => 'Lorem ipsum' } }

      it 'should create a micropost' do
        expect { post :create, :params => { :micropost => @attr } }.to \
        change(Micropost, :count).by(1)                                                                    
      end

      it 'should redirect to the home page' do
        post :create, :params => { :micropost => @attr }
        expect(response).to redirect_to(root_path)
      end

      it 'should have a flash message' do
        post :create, :params => { :micropost => @attr }
        expect(flash[:success]).to match(/micropost created/i)
      end
    end
  end

  describe 'DELETE destroy' do
    describe 'for an unauthorized user' do
      before(:each) do
        @user = FactoryBot.create(:user)
        wrong_user = FactoryBot.create(
          :user, :email => FactoryBot.generate(:email))
        test_sign_in(wrong_user)
        @micropost = FactoryBot.create(:micropost, :user => @user)
      end

      it 'should deny access' do
        delete :destroy, :params => { :id => @micropost }
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'for an authorized user' do
      before(:each) do
        @user = FactoryBot.create(:user)
        test_sign_in(@user)
        @micropost = FactoryBot.create(:micropost, :user => @user)
      end

      it 'should destroy the micropost' do
        expect { delete :destroy, :params => { :id => @micropost } }.to \
        change(Micropost, :count).by(-1)                                                                       
      end
    end
  end

  describe 'from_user_followed_by' do
    before(:each) do
      @user = FactoryBot.create(:user)
      test_sign_in(@user)
      @other_user = FactoryBot.create(
        :user, :email => FactoryBot.generate(:email))
      @third_user = FactoryBot.create(
        :user, :email => FactoryBot.generate(:email))
      @user_post = @user.microposts.create!(:content => 'foo')
      @other_post = @other_user.microposts.create(:content => 'bar')
      @third_post = @third_user.microposts.create(:content => 'baz')
      @user.follow!(@other_user)
    end

    it 'should have a from_users_followed_by class method' do
      expect(Micropost).to respond_to(:from_users_followed_by)
    end

    it "should include the followed user's microposts" do
      expect(Micropost.from_users_followed_by(@user)).to include(@other_post)
    end

    it "should include the user's own microposts" do
      expect(Micropost.from_users_followed_by(@user)).to include(@user_post)
    end

    it "should not include an unfollowed user's microposts" do
      expect(Micropost.from_users_followed_by(@user)).not_to \
                                                        include(@third_post)
    end
  end
end
