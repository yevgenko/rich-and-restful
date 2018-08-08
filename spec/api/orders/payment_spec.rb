require 'rails_helper'

RSpec.describe "POST /orders/:id/payments", type: :request do
  let(:client) { a_client }

  it 'creates resource' do
    order = Order.create amount: 100
    new_payment = Payment.new amount: 100

    client.create_resource order, new_payment
    expect(client).to have_received_created_resource order, new_payment
  end

  def a_client
    RichAndRestfulTests::RestClient.new integration_session
  end
end
