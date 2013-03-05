class Shape < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :graffle

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
     in_menu: in_menu,
     graffle_id: graffle_id,
     properties: properties}
  end

end
