require 'rails_helper'

RSpec.describe "Order Payments", type: :feature, js: true do
  let(:order) { Order.create amount: 100 }
  let(:order_page) { OrderPage.new order }

  context "make payment" do
    before do
      order_page.open
      order_page.make_payment
    end

    it 'changes order status to paid' do
      expect(order_page).to have_status_paid
    end
  end
end
