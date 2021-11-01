require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @attr = { :name => 'Example User', :email => 'user@example.com',
              :password => 'foobar', :password_confirmation => 'foobar' }
  end

  it 'should create a new instance given valid attributes' do
    User.create!(@attr)
  end

  it 'should require a name' do
    no_name_user = User.new(@attr.merge({ :name => '' }))
    expect(no_name_user.valid?).to eq(false)
  end

  it 'should reject names that are too long' do
    long_name_user = User.new(@attr.merge({ :name => 'a' * 51 }))
    expect(long_name_user.valid?).to eq(false)
  end

  it 'should require an email' do
    no_email_user = User.new(@attr.merge({ :email => '' }))
    expect(no_email_user.valid?).to eq(false)
  end

  it 'should accept valid email addresses' do
    valid_emails = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    valid_emails.each do |email|
      valid_email_user = User.new(@attr.merge({ :email => email }))
      expect(valid_email_user.valid?).to eq(true)
    end
  end

  it 'should reject invalid email addresses' do
    invalid_emails = %w[user@foo,com user_at_foo.com example.user@foo.]
    invalid_emails.each do |email|
      invalid_email_user = User.new(@attr.merge({ :email => email }))
      expect(invalid_email_user.valid?).to eq(false)
    end
  end

  it 'should prohibit saving users with the same email address' do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    expect(user_with_duplicate_email.valid?).to eq(false)
  end

  describe 'password validations' do
    it 'should require a password' do
      user_without_password = User.new(
        @attr.merge({ :password => '',
                      :password_confirmation => '' }))
      expect(user_without_password.valid?).to eq(false)
    end

    it 'should require a matching password confirmation' do
      user_invalid_confirmation_password =
        User.new(@attr.merge({ :password_confirmation => 'invalid' }))
      expect(user_invalid_confirmation_password.valid?).to eq(false)
    end

    it 'should reject short passwords' do
      user_short_password =
        User.new(@attr.merge({ :password => 'a' * 5,
                               :password_confirmation => 'a' * 5 }))
      expect(user_short_password.valid?).to eq(false)
    end

    it 'should reject long passwords' do
      user_long_password =
        User.new(@attr.merge({ :password => 'a' * 41,
                               :password_confirmation => 'a' * 41 }))
      expect(user_long_password.valid?).to eq(false)
    end
  end

  describe 'password encryption' do
    before(:each) { @user = User.create!(@attr) }

    it 'should have an encrypted password attribute' do
      expect(@user.respond_to? :encrypted_password).to eq(true)
    end

    it 'should set the encrypted password' do
      expect(@user.encrypted_password.blank?).to eq(false)
    end

    it 'should return true if the passwords match' do
      expect(@user.valid_password?(@attr[:password])).to eq(true)
    end

    it 'should return false if the passwords do not match' do
      expect(@user.valid_password?('invalid_password')).to eq(false)
    end

    describe 'authenticate method' do
      it 'should return nil on email/password mismatch' do
        wrong_password_user = User.authenticate(@attr[:password], 'wrongpass');
        expect(wrong_password_user).to eq(nil)
      end

      it 'should return nil for an email address with no user' do
        nonexistent_user = User.authenticate('bar@foo.com', @attr[:password])
        expect(nonexistent_user).to eq(nil)
      end

      it 'should return the user on email/password match' do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        expect(matching_user).not_to equal (nil)
      end
    end
  end

  describe 'admin attribute' do
    before(:each) do
      @user = User.create!(@attr)
    end

    it 'should respons to admin' do
      expect(@user).to respond_to(:admin)
    end

    it 'should not be an admin by default' do
      expect(@user.admin?).to eq(false)
    end

    it 'should be convertible to an admin' do
      @user.toggle!(:admin)
      expect(@user.admin?).to eq(true)
    end    
  end

  describe 'micropost associations' do
    before(:each) do
      @user = User.create(@attr)
      @mp1 = FactoryBot.create(:micropost,
                               :user => @user,
                               :created_at => 1.day.ago)
      @mp2 = FactoryBot.create(:micropost,
                               :user => @user,
                               :created_at => 1.hour.ago)
    end

    it 'should have a microposts attribute' do
      expect(@user).to respond_to(:microposts)
    end

    it 'should have the right microposts in the right order' do
      expect(@user.microposts).to eq([@mp2, @mp1])
    end

    it "should remove the user's microposts when the user gets deleted" do
      @user.destroy
      [@mp1, @mp2].each do |mp|
        expect(Micropost.find_by_id(mp.id)).to eq(nil)
      end
    end

    describe 'status feed' do
      it 'should have a feed' do
        expect(@user).to respond_to(:feed)
      end

      it "should include the user's microposts" do
        expect(@user.feed.include?(@mp1)).to eq(true)
        expect(@user.feed.include?(@mp2)).to eq(true)
      end

      it "should not include a different user's microposts" do
        mp3 = FactoryBot.create(:micropost,
                                :user => FactoryBot.create(
                                  :user, :email => FactoryBot.generate(:email)))
        expect(@user.feed.include?(mp3)).to eq(false)
      end
      it 'should include the microposts of followed users' do
        followed = FactoryBot.create(
          :user, :email => FactoryBot.generate(:email))
        mp3 = FactoryBot.create(:micropost, :user => followed)
        @user.follow!(followed)
        expect(@user.feed).to include(mp3)
      end
      
    end
  end

  describe 'relationships' do
    before(:each) do
      @user = User.create(@attr)
      @followed = FactoryBot.create(:user)
    end

    it 'should have a relationships method' do
      expect(@user).to respond_to(:relationships)
    end

    it 'should have a following method' do
      expect(@user).to respond_to(:following)
    end

    it 'should have a following method' do
      expect(@user).to respond_to(:following?)
    end

    it 'should have a follow! method' do
      expect(@user).to respond_to(:follow!)
    end

    it 'should follow another user' do
      @user.follow!(@followed)
      expect(@user).to be_following(@followed)
    end

    it 'should include the followed user in the following array' do
      @user.follow!(@followed)
      expect(@user.following).to include(@followed)
    end

    it 'should have an unfollow! method' do
      expect(@followed).to respond_to(:unfollow!)
    end

    it 'should unfollow a user' do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      expect(@user.following).not_to include(@followed)
    end

    it 'should have a reverse_relationships method' do
      expect(@user).to respond_to(:reverse_relationships)
    end

    it 'should have a followers method' do
      expect(@user).to respond_to(:followers)
    end

    it 'should include the follower in the followers array' do
      @user.follow!(@followed)
      expect(@followed.followers).to include(@user)
    end

    
  end
end
