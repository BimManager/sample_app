require 'rails_helper'
require 'factory_bot'

RSpec.describe Relationship, type: :model do
  before(:each) do
    @follower = FactoryBot.create(:user)
    @followed = FactoryBot.create(:user, :email => FactoryBot.generate(:email))
    @relationship = @follower.relationships.build(:followed_id => @followed.id)
  end

  it 'should create a new instance given valid attributes' do
    @relationship.save!
  end

  describe 'follow methods' do
    before(:each) do
      @relationship.save
    end

    it 'should have a follower attribute' do
      expect(@relationship).to respond_to(:follower)
    end

    it 'should have the right follower' do
      expect(@relationship.follower).to eq(@follower)
    end

    it 'should have a followed attribute' do
      expect(@relationship).to respond_to(:followed)
    end

    it 'should have the right followed user' do
      expect(@relationship.followed).to eq(@followed)
    end
  end

  describe 'validations' do
    it 'should require a follower_id' do
      @relationship.follower_id = nil
      expect(@relationship.valid?).to eq(false)
    end

    it 'should require a followed_id' do
      @relationship.followed_id = nil
      expect(@relationship.valid?).to eq(false)
    end
  end
end
