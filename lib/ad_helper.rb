require 'net/ldap'

module AdHelper

  class Connector 
  
    NO_LOGON_HOURS = '0' * 168
    
    def initialize
      config_file = Dir.glob("#{Rails.root}/config/**/ad.yml").first
      config = config_file ? YAML.load_file(config_file)[Rails.env] : {}
      @ldap ||= ::Net::LDAP.new(auth_hash(config))
      @base = config.fetch(:base, '')
      @remote_users = "CN=Remote Desktop Users,CN=Builtin,#{@base}"
    end
  
    def user_exists?(username)
      filter = ::Net::LDAP::Filter.eq("sAMAccountName", username)
      @ldap.search(:filter => filter).length > 0
    end
  
    def create_user_unless_exists(user)
      unless user_exists?(user[:uid])
        create_user(user)
      end
    end 
    
    def create_user(user)    
      dn = "CN=#{user[:uid]}, CN=Users, #{@base}"
	    attrs = {
	      :cn => user[:uid],
	      :samAccountName => user[:uid],
        :sn => user[:last_name],
	      :givenName => user[:first_name],
	      :objectClass => "user"	  
        }
      @ldap.add(:dn => dn, :attributes => attrs)	
	    ops = [
	      [ :replace, :unicodePwd, encode_pwd(user[:password]) ],
	      [ :replace, :userAccountControl, '512' ],
	      [ :replace, :logonHours, bin_to_code(NO_LOGON_HOURS) ]
	    ]	
	    @ldap.modify :dn => dn, :operations => ops
	    @ldap.add_attribute REMOTE_USERS_GROUP, :member, dn
    end
    
    private
    
    def encode_pwd(pwd)
      ['"', *pwd.chars, '"'].map do |char|
        "#{char}\000"
      end.join
    end
    
    def bin_to_code(bstr)
      bstr.scan(/.{8}/).map do |byte|
        byte.reverse.to_i(2)
      end.pack('c*').force_encoding('UTF-8')
    end
    
    def auth_hash(config)
      {
        :host => config.fetch(:host, 'localhost'), 
        :port => config.fetch(:port, 636),
        :base => config.fetch(:base, 'DC=sll,DC=local'),
        :encryption => { 
          :method => :simple_tls
        },
        :auth => {
          :method => :simple,
          :username => config.fetch(:username, ''),
          :password => config.fetch(:password, '')
        }
      }
    end
  end
end
