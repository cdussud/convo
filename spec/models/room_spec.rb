# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  slug       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Room do
  describe "slug" do

    it "should be auto created" do
      15.times do
        room = Room.new
        room.save
        room.reload
        room.slug.should == room.id.to_i.to_s(36)
      end
    end

    it "rejects duplicates" do
      room = Room.new
      room.save
      room.reload
      room2 = Room.new
      room2.slug = room.slug
      expect { room2.save! }.to raise_error
    end

    it "can create custom slugs" do
      room = Room.new
      room.slug = "test"
      room.save!
      room.reload
      room.slug.should == "test"
    end
  end
end
