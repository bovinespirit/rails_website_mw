class CreateGoboWheelGobosData < ActiveRecord::Migration
  def self.up
    StockGobo.find_by_sql("SELECT gobo_wheel_id, lantern_id, max(position) FROM stock_gobos GROUP BY gobo_wheel_id, lantern_id").each do |gwl|
      lan = Lantern.find(gwl.lantern_id)
      gw = GoboWheel.new do |g|
        g.gobo_wheel_type_id = gwl.gobo_wheel_id
        g.gobo_size_id = lan.gobo_size_id
        g.quantity = gwl.max
      end
      gw.lanterns << lan
      gw.save!
      StockGobo.find_all_by_lantern_id_and_gobo_wheel_id(lan.id, gwl.gobo_wheel_id). each do |sg|
        gwg = GoboWheelsGobo.new do |g|
          g.gobo_wheel_id = gw.id
          g.gobo_id = sg.gobo_id
          g.position = sg.position
        end
        gwg.save!
      end
    end
  end

  def self.down
  end
end
