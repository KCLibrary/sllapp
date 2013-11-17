class User < ActiveRecord::Base
  rolify
  devise :sip2_authenticatable, :rememberable, :trackable

  has_many :reservations
  validates_uniqueness_of :uid
  attr_accessible :uid, :last_name, :first_name, :email, :remember_me, :password
  attr_accessor :password

  def values_for_create_ad_user
    [uid, uid, last_name, first_name]
  end

  def after_sip2_validation(auth_hash)
    self.assign_attributes({ 
      :last_name => auth_hash[:last_name],
      :first_name => auth_hash[:first_name],
      :email => auth_hash[:email],
      :password => auth_hash[:password]
    })
    Thread.new { AdHelper::User.new(self).create }
  end

end
