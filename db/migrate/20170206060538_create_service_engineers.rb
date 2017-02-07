class CreateServiceEngineers < ActiveRecord::Migration
  def change
    create_table :service_engineers do |t|
      t.string :name
      t.float :latitude
      t.text :location
      t.float :longitude

      t.timestamps null: false
    end
  end
end
