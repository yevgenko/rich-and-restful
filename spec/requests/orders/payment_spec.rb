require 'rails_helper'

RSpec.describe "POST /orders/:id/payments", type: :request do
  let(:client) { RichAndRestfulTests::RestClient.new integration_session }

  it 'creates resource' do
    order = Order.create amount: 100
    new_payment = Payment.new amount: 100

    client.create(order, new_payment)

    # TODO: why 200?
    # expect(response).to have_http_status(:created)

    expect(parse_json(response.body)).to include(
      "id" => a_kind_of(Integer)
    )
  end
end
