class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :customer_id
      t.string :status
      t.time :raised_at

      t.timestamps null: false
    end
  end
end
