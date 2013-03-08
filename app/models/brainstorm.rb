class Brainstorm < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  PHASES = ['first_department',
            'second_department',
            'your_department',
            'voting',
            'consolidation']

  has_many :users
           order: 'name'

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

  def next_phase
    PHASES[PHASES.index(phase) + 1]
  end

  def init_graffles
    first_department_graffle = Graffle.create properties: {name: 'Department A'}
    second_department_graffle = Graffle.create properties: {name: 'Department B'}
    consolidation_graffle = Graffle.create properties: {name: 'Consolidation'}
  end

  def your_department_graffle
    user.your_department_graffle
  end

  def graffles
    [first_department_graffle, second_department_graffle, your_department_graffle, consolidation_graffle]
  end

  def current_graffle
    send "#{phase}_graffle"
  end

  def properties
    self[:properties] ||= {}
  end

  def as_json
    {id: id,
     phase: phase,
     properties: properties,
     state: state}
  end

end
