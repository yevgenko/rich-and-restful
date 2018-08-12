class Order < ApplicationRecord
  include AASM

  aasm do
    state :pending, :initial => true
    state :paid

    event :payment_created do
      transitions from: :pending, to: :paid
    end
  end

  has_one :payment
end
