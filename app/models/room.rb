# == Schema Information
#
# Table name: rooms
#
#  id            :integer          not null, primary key
#  slug          :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  session_token :string(255)      not null
#

class Room < ActiveRecord::Base
  attr_accessible :slug
  validates_uniqueness_of :slug

  before_create :parse_slug
  after_save :create_slug

  def to_param  # override to use the slug instead of id in all urls
    slug
  end

  private

  def parse_slug
    self.slug = slug.parameterize unless slug.blank?
  end

  def create_slug
    # ugh - prob better way
    if slug.blank?
      self.slug = id.to_i.to_s(36) # just change base of the integer
      self.save
    end
  end
end
