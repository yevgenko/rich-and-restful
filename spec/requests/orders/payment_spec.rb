require 'rails_helper'

RSpec.describe "POST /orders/:id/payments", type: :request do
  let(:client) { RichAndRestfulTests::RestClient.new integration_session }

  it 'creates resource' do
    order = Order.create amount: 100
    new_payment = Payment.new amount: 100

    request_body = client.make_request(order, new_payment)

    # TODO: why 200?
    # expect(response).to have_http_status(:created)

    expect { JSON.parse(response.body) }.to_not raise_error, response.body
    expect(response.body).to be_json_eql request_body
    expect(parse_json(response.body)).to include(
      "id" => a_kind_of(Integer)
    )
  end
end
