class Payment < ApplicationRecord
  belongs_to :order
  after_create :notify_order

  private

  def notify_order
    order.payment_created!
  end
end
