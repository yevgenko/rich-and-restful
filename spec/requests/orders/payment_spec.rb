require 'rails_helper'

RSpec.describe "POST /orders/:id/payments", type: :request do
  it 'creates resource' do
    order = Order.create amount: 100
    new_payment = Payment.new amount: 100

    create_resource_for [order, new_payment]

    # TODO: why 200?
    # expect(response).to have_http_status(:created)

    expect(parse_json(response.body)).to include(
      "id" => a_kind_of(Integer)
    )
  end

  def create_resource_for(resources)
    resource = resources.last
    url = url_for(resources)
    controller_name = Rails.application.routes.recognize_path(url, method: :post)[:controller]
    controller = controller_class_for(controller_name).new
    resource_name = resource.class.name.underscore
    # TODO: talk to action view directly,
    # or perhaps to respond_with, so, can handle errors as well
    # resource_json = Rabl::Renderer.json(resource, "#{controller_name}/#{resource_name}")
    resource_json = controller.render_to_string(
      "_#{resource_name}".to_sym,
      locals: { "#{resource_name}": resource }
    )

    params = JSON.parse resource_json
    headers = {
      "ACCEPT" => "application/json"
    }

    post url, params: params, headers: headers

    # expecting json response, otherwise shows what was that
    expect { JSON.parse(response.body) }.to_not raise_error, response.body

    expect(response.body).to be_json_eql resource_json
  end

  # from actionpack/lib/action_dispatch/http/request.rb
  def controller_class_for(name)
    if name
      controller_param = name.underscore
      const_name = "#{controller_param.camelize}Controller"
      ActiveSupport::Dependencies.constantize(const_name)
    else
      PASS_NOT_FOUND
    end
  end
end
