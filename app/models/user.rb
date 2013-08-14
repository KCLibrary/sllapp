class User < ActiveRecord::Base
  rolify
  devise :sip2_authenticatable, :rememberable, :trackable

  has_many :reservations
  validates_uniqueness_of :uid
  attr_accessible :uid, :last_name, :first_name, :email, :password, :remember_me

  def sip2_before_save(auth_hash)
    self.assign_attributes({ 
      :last_name => auth_hash[:last_name],
      :first_name => auth_hash[:first_name],
      :email => auth_hash[:email]
    })
  end

end
