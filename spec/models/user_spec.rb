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
end
