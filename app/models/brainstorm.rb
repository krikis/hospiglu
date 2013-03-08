class Brainstorm < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  PHASES = ['first_department',
            'second_department',
            'your_department',
            'voting',
            'consolidation']

  has_many :users,
           order: 'name'

  has_many :graffles

  serialize :properties

  after_create :init_graffles

  def phase
    self[:phase] || PHASES.first
  end

  def next_phase
    if phase
      PHASES[PHASES.index(phase) + 1]
    else
      PHASES.first
    end
  end

  def init_graffles
    Graffle.create graffle_type: 'first_department', brainstorm: self
    Graffle.create graffle_type: 'second_department', brainstorm: self
    Graffle.create graffle_type: 'consolidation', brainstorm: self
  end

  def current_graffle_with(user)
    graffles.where(graffle_type: phase).first || user.your_department_graffle
  end

  def properties
    self[:properties] ||= {}
  end

  def as_json(options={})
    {id: id,
     phase: phase,
     properties: properties,
     state: state,
     created_at: created_at}
  end

end
