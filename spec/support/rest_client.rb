class RestClient
  include RSpec::Matchers
  include JsonSpec::Matchers

  def initialize(session)
    @session = session
  end

  def create(*resources)
    resource = resources.last
    url = @session.url_for(resources)
    controller_name = Rails.application.routes.recognize_path(url, method: :post)[:controller]
    controller = controller_class_for(controller_name).new
    resource_name = resource.class.name.underscore
    resource_json = controller.render_to_string(
      "_#{resource_name}".to_sym,
      locals: { "#{resource_name}": resource }
    )

    params = JSON.parse resource_json
    headers = {
      "ACCEPT" => "application/json"
    }

    @session.post url, params: params, headers: headers

    # expecting json response, otherwise shows what was that
    expect { JSON.parse(@session.response.body) }.to_not raise_error, @session.response.body

    expect(@session.response.body).to be_json_eql resource_json
  end

  private

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
