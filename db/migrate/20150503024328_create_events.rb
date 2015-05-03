class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.float :lat
      t.float :lng
      t.integer :user_id
      t.string :category
      t.string :name
      t.datetime :entered_at
      t.integer :time_spent

      t.timestamps null: false
    end
  end
end
