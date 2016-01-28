class CreateBillingEvents < ActiveRecord::Migration
  def change
    create_table :billing_events do |t|
      t.integer :user_id, :null => false
      t.integer :previous_plan_id, :null => false
      t.integer :new_plan_id, :null => false
      t.integer :billing_source, :null => false
      t.string :token

      t.timestamps
    end
  end
end
