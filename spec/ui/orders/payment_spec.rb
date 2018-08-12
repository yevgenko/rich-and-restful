require 'rails_helper'

RSpec.describe "Order Payment Request", type: :feature, js: true do
  let(:app) { page.app }
  let(:order_page) { a_page }
  let(:order) { Order.create amount: 100 }
  let(:new_payment) { Payment.new amount: 100 }

  after { app.verify }

  context "click Pay button" do
    before do
      order_page.ensure_on order
    end

    it 'makes request' do
      expect(app).to have_received_post_request order, new_payment
      order_page.pay
    end
  end

  def a_page
    RichAndRestfulTests::OrderPage.new
  end
end
