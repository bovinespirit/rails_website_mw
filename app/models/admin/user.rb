# Fake ActiveRecord class
# TODO: put password elsewhere
require "digest/sha1"

module Admin
  class User
    attr_accessor :name, :password
    
    def initialize(params = { })
      params = {} if !params
      @name = params[:name] || ""
      @password = params[:password] || ""
    end
    
    def try_to_login()
#      hashed_password = hash_password(password)
      s = (@name == 'memyself' and @password == 'ar5ecr1sps') ? true : false
      return s
    end
    
    private
    def self.hash_password(password)
      Digest::SHA1.hexdigest(password)
    end
  end
end
