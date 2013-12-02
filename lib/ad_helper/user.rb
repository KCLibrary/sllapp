require 'net/ldap'

module AdHelper

  class User 
  
    NORMAL_USER_FLAG = '66048'
    
    attr_reader :app_user
    
    def initialize(app_user = nil)
      @app_user = app_user
    end
  
    def ad_user_exists?
      !ad_user.nil?
    end
  
    def current_logon_hours
      Connector.code_to_bin(ad_user[:logonHours].first) if ad_user_exists?
    end
  
    def ad_user
      filter = Net::LDAP::Filter.eq("sAMAccountName", app_user.uid)
      Connector.connection.search(:filter => filter).first
    end
  
    def dn
      Connector.dn_for_user(app_user.uid)
    end
    
    def initial_attrs
      _k = [:cn, :samAccountName, :sn, :givenName]
      _v = app_user.values_for_create_ad_user
      Hash[ _k.zip(_v) ].merge(:objectClass => "user")
    end
    
    def update_ops
      [[ :replace, :unicodePwd, encoded_pwd ],
      [ :replace, :userAccountControl, NORMAL_USER_FLAG ],
      [ :replace, :logonHours, Connector.no_logon_hours_formatted ]]
    end
    
    def conn
      Connector.connection
    end
    
    def add_to_remote_users_group
      conn.add_attribute Connector.remote_users_group, :member, dn
      conn.add_attribute Connector.remote_users_security_group, :member, dn
    end
    
    def create
      return if ad_user_exists?
      conn.add(:dn => dn, :attributes => initial_attrs)	
	    conn.modify(:dn => dn, :operations => update_ops)
	    add_to_remote_users_group
    end
    
    def delete
      conn.delete(:dn => dn) if ad_user_exists?
    end
    
    def encoded_pwd
      Connector.encode_pwd(app_user.password) unless app_user.password.nil?
    end    
    
  end
end
