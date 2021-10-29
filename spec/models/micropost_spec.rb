require 'rails_helper'
require 'factory_bot'

RSpec.describe Micropost, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
    @attr = { :content => 'value for content' }
  end

  it 'should create a new instance given valid attributes' do
    @user.microposts.create!(@attr)
  end
    
  describe 'user associations' do
    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end

    it 'should have a user attribute' do
      expect(@micropost).to respond_to(:user)
    end

    it 'should have the right associated user' do
      expect(@micropost.user_id).to eq(@user.id)
      expect(@micropost.user).to eq(@user)
    end
  end

  describe 'validations' do
    it 'should require a user id' do
      expect(Micropost.new(@attr).valid?).to eq(false)
    end

    it 'should require nonblank content' do
      expect(@user.microposts.build(:content => ' ').valid?).to eq(false)
    end

    it 'should reject long content' do
      expect(@user.microposts.build(:content => 'a' * 141).valid?).to eq(false)
    end
  end
end
