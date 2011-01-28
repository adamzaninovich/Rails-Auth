class User
  #attr_accessible :username, :email, :password, :password_confirmation
  attr_accessor :password
  include Mongoid::Document
  
  #include Mongoid::Document::ProtectedAttributes # implement this with http://blog.eizesus.com/2010/03/creating-a-rails-authentication-system-on-mongoid/
  #attr_protected :password_hash, :password_salt
  
  field :username
  field :email
  field :password_hash
  field :password_salt
  
  before_save :prepare_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: {with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, message: "is not a valid email address."}
  
  # can use username or email
  def self.authenticate login, pass
    user = first(conditions: {username: login}) || first(conditions: {email: login})
    ( user && user.matching_password?(pass) ) ? user : nil
  end
  
  def matching_password? pass
    self.password_hash == encrypt_password(pass)
  end
  
  private
    
  def prepare_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password password
    end
  end
  
  def encrypt_password pass
    BCrypt::Engine.hash_secret(pass, password_salt)
  end
end
