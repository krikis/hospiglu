class User < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :brainstorm

  has_one :your_department_graffle,
          class_name: 'Graffle',
          foreign_key: 'user_id'

  serialize :properties

  after_create :init_graffle

  validates :name, presence: true, uniqueness: {scope: [:brainstorm_id]}

  def init_graffle
    Graffle.create properties: {name: "#{name}'s Department"}, user: self, brainstorm: brainstorm
  end

  def properties
    self[:properties] ||= {}
  end

  def as_json(options={})
    {id: id,
     brainstorm_id: brainstorm_id,
     properties: properties}
  end

end
