class Graffle < ActiveRecord::Base

  has_many :shapes
  has_many :connections
  has_many :menu_shapes,
           class_name: "Shape",
           foreign_key: "menu_id"
  has_many :menu_connections,
           class_name: "Shape",
           foreign_key: "menu_id"

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
