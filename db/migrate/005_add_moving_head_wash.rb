class AddMovingHeadWash < ActiveRecord::Migration
  def self.up
    profile = LanternType.find_by_name("Moving Head Profile")
    wash = LanternType.find_by_name("Moving Head Wash")
    Lantern.find_all_by_gobo_size_id_and_lantern_type_id(0, profile.id).each do |lan|
      lan.lantern_type = wash
      lan.save!
    end
  end

  def self.down
    profile = LanternType.find_by_name("Moving Head Profile")
    wash = LanternType.find_by_name("Moving Head Wash")
    Lantern.find_all_by_lantern_type_id(wash.id).each do |lan|
      lan.lantern_type = profile
      lan.gobo_size_id = 0
      lan.save!
    end
  end
end
