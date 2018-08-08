module RichAndRestfulTests
  class Resource
    include Rails.application.routes.url_helpers

    def initialize(models)
      default_url_options[:only_path] = true
      @models = models
      @model = models.last
    end

    def location
      url_for @models
    end

    def payload
      controller_name = Rails.application.routes.recognize_path(
        location, method: :post
      )[:controller]
      controller = controller_class_for(controller_name).new
      resource_name = @model.class.name.underscore

      controller.render_to_string(
        "_#{resource_name}".to_sym,
        locals: { "#{resource_name}": @model }
      )
    end

    def errors
      @model.valid?
      { :errors => @model.errors }.to_json
    end

    def headers
      {
        "CONTENT_TYPE" => 'application/json',
        "ACCEPT" => "application/json"
      }
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
