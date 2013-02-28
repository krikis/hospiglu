class Connection < ActiveRecord::Base

  serialize :properties

  def properties
    self[:properties] ||= {}
  end
  
end
