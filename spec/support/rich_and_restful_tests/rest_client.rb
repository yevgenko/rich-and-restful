module RichAndRestfulTests
  class RestClient
    def initialize(session)
      @session = session
    end

    def make_request(*resources)
      resource = resources.last
      url = @session.url_for(resources)
      controller_name = Rails.application.routes.recognize_path(url, method: :post)[:controller]
      controller = controller_class_for(controller_name).new
      resource_name = resource.class.name.underscore
      resource_json = controller.render_to_string(
        "_#{resource_name}".to_sym,
        locals: { "#{resource_name}": resource }
      )

      headers = {
        "CONTENT_TYPE" => 'application/json',
        "ACCEPT" => "application/json"
      }

      @session.post url, params: resource_json, headers: headers

      resource_json # request body
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
end
