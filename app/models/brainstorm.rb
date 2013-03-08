class Brainstorm < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  has_many :users

  has_one :first_department_graffle,
           class_name: 'Graffle',
           foreign_key: 'brainstorm_id'

  has_one :second_department_graffle,
          class_name: 'Graffle',
          foreign_key: 'brainstorm_id'

  has_one :consolidation_graffle,
          class_name: 'Graffle',
          foreign_key: 'brainstorm_id'

  serialize :properties

  after_create :init_graffles

  def init_graffles
    first_department_graffle = Graffle.create properties: {name: 'Department A'}
    second_department_graffle = Graffle.create properties: {name: 'Department B'}
    consolidation_graffle = Graffle.create properties: {name: 'Consolidation'}
  end

  def properties
    self[:properties] ||= {}
  end

  def as_json
    {id: id,
     properties: properties,
     state: state}
  end

end
