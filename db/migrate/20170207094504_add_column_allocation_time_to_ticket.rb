class AddColumnAllocationTimeToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :allocated_slot, :time
  end
end
