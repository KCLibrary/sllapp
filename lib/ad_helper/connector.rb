require 'net/ldap'

module AdHelper

  class Connector 
  
    NO_LOGON_HOURS  = '0' * 168
    ENCRYPTION      = { :method => :simple_tls }
    AUTH_METHOD     = { :method => :simple }

    def self.config
      @config ||= begin
        _cf = Dir.glob("#{Rails.root}/config/**/ad.yml").first
        YAML.load(ERB.new(File.read(_cf)).result)[Rails.env]
      end
    end
    
    def self.base
      @base ||= config[:base]
    end
    
    def self.remote_users_group
      @remote_users_group ||= begin
        "CN=Remote Desktop Users,CN=Builtin,#{base}"
      end
    end
    
    def self.remote_users_security_group
      @remote_users_security_group ||= begin
        "CN=SLL - Remote Desktop Users,OU=Security,OU=SLL - Groups,#{base}"
      end
    end
    
    def self.connection_settings
      config.slice(:host, :port, :base).merge({
        :encryption => ENCRYPTION,
        :auth => config.slice(:username, :password).merge(AUTH_METHOD)
      })
    end
    
    def self.connection
      @connection ||= Net::LDAP.new(connection_settings)
    end
  
    def self.no_logon_hours_formatted
      bin_to_code(NO_LOGON_HOURS)
    end
  
    def self.encode_pwd(pwd)
      ['"', *pwd.chars, '"'].map do |char|
        "#{char}\000"
      end.join
    end
    
    def self.bin_to_code(bstr)
      bstr.scan(/.{8}/).map do |byte|
        byte.reverse.to_i(2)
      end.pack('c*').force_encoding('UTF-8')
    end
  
    def self.code_to_bin(str)
      str.unpack('b*').join
    end
  
    def self.dn_for_user(cn)
      "CN=#{cn}, CN=Users, #{base}"
    end
  
  end
end
