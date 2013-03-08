class Graffle < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :brainstorm

  belongs_to :user

  has_many :shapes

  has_many :connections

  serialize :properties

  def properties
    self[:properties] ||= {}
  end

  def as_json(options={})
    {id: id,
     brainstorm_id: brainstorm_id,
     user_id: user_id,
     properties: properties,
     updated_at: updated_at}
  end

end
