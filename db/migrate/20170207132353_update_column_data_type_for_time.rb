class UpdateColumnDataTypeForTime < ActiveRecord::Migration
  def change
    remove_column :tickets, :raised_at
    remove_column :tickets, :allocated_slot
    add_column :tickets, :raised_at, :datetime
    add_column :tickets, :allocated_slot, :datetime
  end
end
