class UsePostGisColumn < ActiveRecord::Migration
  def change
    remove_column :locations, :lat
    remove_column :locations, :lng
    add_column :locations, :lonlat, :st_point, geographic: true
  end
end
