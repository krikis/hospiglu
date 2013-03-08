class User < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :brainstorm

  has_one :your_department_graffle

  serialize :properties

  after_create :init_graffle

  validates_presence_of :name

  def init_graffle
    your_department_graffle = Graffle.create properties: {name: "#{name}'s Department"}
  end

  def properties
    self[:properties] ||= {}
  end

  def as_json
    {id: id,
     brainstorm_id: brainstorm_id,
     properties: properties}
  end

end
