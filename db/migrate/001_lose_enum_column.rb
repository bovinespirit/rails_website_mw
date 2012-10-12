class LoseEnumColumn < ActiveRecord::Migration
  def self.up
    add_column :beam_angles, :temp_opt, :boolean, :default => false
    BeamAngle.reset_column_information
    BeamAngle.find(:all).each do |ba|
      ba.temp_opt = true if ba.optional == "optional"
      if !ba.save
        puts "Error! id: #{ba.id}"
        ba.errors.full_messages.each { |m| puts m }
      end
    end
    remove_column :beam_angles, :optional
    rename_column :beam_angles, :temp_opt, :optional
  end

  def self.down
  end
end
