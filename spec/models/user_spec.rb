require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @attr = { :name => 'Example User', :email => 'user@example.com' }
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
end
