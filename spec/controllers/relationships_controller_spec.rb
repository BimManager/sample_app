require 'rails_helper'
require 'factory_bot'

describe RelationshipsController do
  describe 'access control' do
    it 'should require signin for create' do
      post :create
      expect(response).to redirect_to(signin_path)
    end

    it 'should require signin for destroy' do
      delete :destroy, :params => { :id => 1 }
      expect(response).to redirect_to(signin_path)
    end
  end

  describe 'POST create' do
    before(:each) do
      @user = FactoryBot.create(:user)
      test_sign_in(@user)
      @followed = FactoryBot.create(
        :user, :email => FactoryBot.generate(:email))
    end

    it 'should create a relationship' do
      expect { post :create, :params => {
                      :relationship => { :followed_id => @followed } } }.to \
                                              change(Relationship, :count).by(1)
      expect(response).to be_redirect
    end

    it 'should create a relationship using Ajax' do
      expect { post :create, xhr: true, :params => {
                     :relationship => { :followed_id => @followed } } }.to \
                       change(Relationship, :count).by(1)
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      @user = FactoryBot.create(:user)
      test_sign_in(@user)
      @followed = FactoryBot.create(
        :user, :email => FactoryBot.generate(:email))
      @user.follow!(@followed)
      @relationship = @user.relationships.find_by_followed_id(@followed)
    end

    it 'should destroy a relationship' do
      expect { delete :destroy, :params => { :id => @relationship }}.to \
                                             change(Relationship, :count).by(-1)
      expect(response).to be_redirect
    end

    it 'should destroy a relationship using Ajax' do
      expect { delete :destroy, xhr: true, :params => {
                        :id => @relationship } }.to \
                           change(Relationship, :count).by(-1)
    end
  end
end
