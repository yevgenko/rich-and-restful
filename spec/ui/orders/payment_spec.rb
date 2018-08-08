require 'rails_helper'

RSpec.describe "Order Payment Request", type: :feature, js: true do
  let(:app) { page.app }
  let(:order_page) { a_page }
  let(:order) { Order.create amount: 100 }
  let(:new_payment) { Payment.new amount: 100 }

  context "click Pay button" do
    before do
      app.catch_requests = true
      order_page.ensure_on order
      order_page.pay
    end

    it 'makes request' do
      expect(app).to have_received_post_request order, new_payment
    end
  end

  def a_page
    RichAndRestfulTests::OrderPage.new
  end
end
