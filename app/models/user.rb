class User < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :brainstorm

  has_one :your_department_graffle

  serialize :properties

  def properties
    self[:properties] ||= {}
  end

  def as_json
    {id: id,
     properties: properties}
  end

end
