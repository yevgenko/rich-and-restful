class Order < ApplicationRecord
  include AASM

  aasm do
    state :pending, :initial => true
  end
end
