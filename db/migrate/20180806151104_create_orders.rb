class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :number
      t.text :lines
      t.decimal :amount

      t.timestamps
    end
  end
end
