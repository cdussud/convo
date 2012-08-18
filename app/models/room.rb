# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  slug       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Room < ActiveRecord::Base
  attr_accessible :slug
  validates_uniqueness_of :slug
  after_save :create_slug

  private
  def create_slug
    # ugh - prob better way
    if slug.blank?
      self.slug = id.to_i.to_s(36) # just change base of the integer
      self.save
    end
  end
end
