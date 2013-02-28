class Shape < ActiveRecord::Base

  belongs_to :graffle

  has_many :outgoing_connections,
           class_name: "Shape",
           foreign_key: "start_shape_id"

  has_many :incoming_connections,
           class_name: "Shape",
           foreign_key: "end_shape_id"

  serialize :properties

  def properties
    self[:properties] ||= {}
  end

end
