class Connection < ActiveRecord::Base

  belongs_to :graffle

  belongs_to :start_shape,
             class_name: "Shape",
             foreign_key: "start_shape_id"

  belongs_to :end_shape,
             class_name: "Shape",
             foreign_key: "end_shape_id"

  serialize :properties

  def properties
    self[:properties] ||= {}
  end

  def as_json(options={})
    {id: id,
     graffle_id: graffle_id,
     in_menu: in_menu,
     properties: properties,
     start_shape_id: start_shape_id,
     end_shape_id: end_shape_id}
  end

end
