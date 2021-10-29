require 'digest'

class User < ApplicationRecord
  #  attr_accessor :name, :email
  attr_accessor :password

  has_many :microposts, :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i;
  
  validates :name,
            :presence => true,
            :length => { :maximum => 50 }
  validates :email,
            :presence => true,
            :format => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }
  validates :password,
            :confirmation => true,
            :length => { :within => 6..40 }

  before_save :encrypt_password

  def self.authenticate(email, password)
    user = self.find_by(:email => email)
    (user and user.valid_password?(password)) ? user : nil
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def valid_password?(submitted_password)
    self.encrypted_password.eql? encrypt(submitted_password)
  end

  private

  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(self.password)
  end

  def encrypt(string)
    secure_hash("#{self.salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{self.password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end
