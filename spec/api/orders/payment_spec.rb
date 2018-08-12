require 'rails_helper'

RSpec.describe "POST /orders/:id/payments", type: :request do
  let(:api) { an_api }

  it 'creates resource' do
    order = Order.create amount: 100
    new_payment = Payment.new amount: 100

    api.create_resource order, new_payment
    expect(api).to have_responded_with_resource_created order, new_payment
  end

  def an_api
    RichAndRestfulTests::ApiRunner.new integration_session
  end
end
