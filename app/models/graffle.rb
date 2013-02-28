class Graffle < ActiveRecord::Base

  has_many :shapes
  has_many :connections

  serialize :properties

  def properties
    self[:properties] ||= {}
  end

  def as_json(options={})
    {id: id,
     properties: properties,
     updated_at: updated_at}
  end

end
