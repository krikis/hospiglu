class Graffle < ActiveRecord::Base
  
  serialize :properties
  
  def properties
    self[:properties] ||= {}
  end
  
end
