class Resource < ActiveRecord::Base
  attr_accessible :description, :type
	has_many :reservations
  
  def self._all
    @_all ||= self.all
  end
  
  def self._find_by_id(id)
    _all.detect{|r| r.id == id }
  end
	
end
