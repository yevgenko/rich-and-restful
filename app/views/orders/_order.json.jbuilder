json.(@order, :id, :amount)
json.status @order.aasm_state
