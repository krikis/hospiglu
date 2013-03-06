class User < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :session

  has_one :graffle

  serialize :properties

  def properties
    self[:properties] ||= {}
  end

  def as_json
    {id: id,
     properties: properties}
  end

end
