class AddOrderIdToPayment < ActiveRecord::Migration[5.2]
  def change
    add_reference :payments, :order, foreign_key: true
  end
end
