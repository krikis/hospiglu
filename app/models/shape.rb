class Shape < ActiveRecord::Base

  serialize :properties

  def properties
    self[:properties] ||= {}
  end

end
