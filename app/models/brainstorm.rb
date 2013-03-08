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

  def properties
    self[:properties] ||= {}
  end

  def as_json
    {id: id,
     properties: properties
     state: state}
  end

end
