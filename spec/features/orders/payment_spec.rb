require 'rails_helper'

RSpec.describe "Order Payments", type: :feature, js: true do
  let(:app)   { an_application }
  let(:order) { Order.create amount: 100 }

  context "make payment" do
    it 'changes order status to paid' do
      expect(app).to have_shown_order_is_pending order
      app.pay_for order
      expect(app).to have_shown_order_is_paid order
    end
  end

  def an_application
    RichAndRestfulTests::ApplicationRunner.new
  end
end
