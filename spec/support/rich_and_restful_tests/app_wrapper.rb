module RichAndRestfulTests
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

    def has_received_post_request?(*models)
      resource = resource_for models

      # expecting json request, otherwise shows what was that
      expect { JSON.parse(last_request.body) }.to_not raise_error, last_request.body
      expect(last_request.body).to be_json_eql resource.payload
      expect(last_request.request.path).to eq resource.location
      expect(last_request.request.request_method_symbol).to eq :post
    end

    def resource_for(models)
      RichAndRestfulTests::Resource.new(models)
    end
  end
end
