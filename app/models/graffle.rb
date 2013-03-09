class Graffle < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :brainstorm

  belongs_to :user

  has_many :shapes

  has_many :connections

  serialize :properties

  after_create :init_menu

  def init_menu
    add_shape shape_type: 'rect', x: 30, y: 30, width: 60, height: 40, border_radius: 10
    add_shape shape_type: 'rect', x: 130, y: 30, width: 60, height: 40, border_radius: 2
    add_shape shape_type: 'ellipse', x: 260, y: 50, width: 30, height: 20
    add_shape shape_type: 'ellipse', x: 350, y: 50, width: 20, height: 20
    add_connection type: 'curvedpath', stroke: '#fff', target: {:'stroke-width' => 20},
                   x: 400, y: 30, x2: 440, y2: 70, cx: 400, cy: 50, cx2: 440, cy2: 50
    add_connection type: 'curvedpath', stroke: '#000', background: {stroke: '#fff', :'stroke-width' => 3},
                   target: {:'stroke-width' => 20}, x: 480, y: 30, x2: 520, y2: 70, cx: 480, cy: 50, cx2: 520, cy2: 50
    add_connection type: 'curvedpath', stroke: '#fff', :'stroke-width' => 5, target: {:'stroke-width' => 20},
                   x: 560, y: 30, x2: 600, y2: 70, cx: 560, cy: 50, cx2: 600, cy2: 50
    add_connection type: 'trashcan', x: 640, y: 35, size: 2, stroke: '#fff', select_color: '#d14',
                   target: {type: 'rectangle', x: 630, y: 20, height: 60, width: 50}
  end

  def add_shape(properties)
    Shape.create graffle: self,
                 in_menu: true,
                 properties: properties
  end

  def add_connection(properties)
    Connection.create graffle: self,
                      in_menu: true,
                      properties: properties
  end

  def properties
    self[:properties] ||= {}
  end

  def as_json(options={})
    {id: id,
     brainstorm_id: brainstorm_id,
     user_id: user_id,
     graffle_type: graffle_type,
     properties: properties,
     updated_at: updated_at}
  end

end
