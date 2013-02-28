class Graffle < ActiveRecord::Base

  has_many :shapes
  has_many :connections

  serialize :properties

  def properties
    self[:properties] ||= {}
  end

end
