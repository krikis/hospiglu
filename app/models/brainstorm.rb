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

  after_create :init_graffles, :init_phases

  def properties
    self[:properties] ||= {}
  end

  def init_graffles
    Graffle.create graffle_type: 'first_department', brainstorm: self
    Graffle.create graffle_type: 'second_department', brainstorm: self
    Graffle.create graffle_type: 'consolidation', brainstorm: self
  end

  def init_phases
    properties[:phases] ||= PHASES
    save!
  end

  def phases
    properties[:phases]
  end

  def phase
    self[:phase] || phases.first
  end

  def next_phase
    if phase
      phases[phases.index(phase) + 1]
    else
      phases.first
    end
  end

  def current_graffles_with(user)
    if phase == 'your_department'
      [graffles.where(graffle_type: 'first_department').first,
       graffles.where(graffle_type: 'second_department').first,
       user.your_department_graffle]
    elsif phase == 'voting'
      graffles.where('user_id is not null')
    else
      graffles.where(graffle_type: phase)
    end
  end

  def as_json(options={})
    {id: id,
     phase: phase,
     phases: phases,
     properties: properties,
     state: state,
     created_at: created_at}
  end

end
