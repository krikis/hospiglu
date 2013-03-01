class Shape < ActiveRecord::Base

  belongs_to :graffle
  belongs_to :menu,
             class_name: "Shape",
             foreign_key: "menu_id"

  has_many :outgoing_connections,
           class_name: "Connection",
           foreign_key: "start_shape_id"

  has_many :incoming_connections,
           class_name: "Connection",
           foreign_key: "end_shape_id"

  serialize :properties

  def properties
    self[:properties] ||= {}
  end

  def as_json(options={})
    {id: id,
     graffle_id: graffle_id,
     properties: properties}
  end

end
