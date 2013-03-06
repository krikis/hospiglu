class Session < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  has_many :users

  has_one :department_a_graffle,
           class_name: 'Graffle',
           foreign_key: 'session_id'

  has_one :department_b_graffle,
          class_name: 'Graffle',
          foreign_key: 'session_id'

  has_one :consolidation_graffle,
          class_name: 'Graffle',
          foreign_key: 'session_id'

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
