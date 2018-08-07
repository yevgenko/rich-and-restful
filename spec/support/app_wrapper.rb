class AppWrapper
  Request = Struct.new :request, :body

  include RSpec::Matchers
  include JsonSpec::Matchers

  attr_reader :last_request
  attr_accessor :catch_requests

  def initialize(app)
    @catch_requests = false
    @app = app
  end

  def call(env)
    if @catch_requests
      user_request = ActionDispatch::Request.new(env)

      @last_request = Request.new(
        user_request,
        user_request.body.read
      )

      user_request.body.rewind
    end

    @app.call(env)
  end

  def has_received_request?(resources)
    resource = resources.last
    controller = last_request.request.controller_class.new
    controller.request = last_request.request

    resource_name = resource.class.name.underscore
    resource_json = controller.render_to_string(
      "_#{resource_name}".to_sym,
      locals: { "#{resource_name}": resource }
    )

    # expecting json request, otherwise shows what was that
    expect { JSON.parse(last_request.body) }.to_not raise_error, last_request.body
    expect(last_request.body).to be_json_eql resource_json
    expect(controller.url_for).to eq controller.url_for(resources)
    expect(controller.request.request_method_symbol).to eq :post
  end
end
