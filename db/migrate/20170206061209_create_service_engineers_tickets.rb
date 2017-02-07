class CreateServiceEngineersTickets < ActiveRecord::Migration
  def change
    create_table :service_engineers_tickets do |t|
      t.integer :service_engineer_id
      t.integer :ticket_id
      t.timestamps null: false
    end
  end
end
