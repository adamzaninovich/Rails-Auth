class User
  attr_accessible :username, :email, :password, :password_confirmation
  attr_accessor :password
  include Mongoid::Document
  field :username
  field :email
  field :password_hash
  field :password_salt
  
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  
  def self.authenticate username, password
    user = where(username: username).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
