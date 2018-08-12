module RichAndRestfulTests
  class AppWrapper
    TestRequest = Struct.new :request, :path, :method, :body

    attr_reader :debug_log
    attr_accessor :debug

    def initialize(app)
      @debug = false
      @debug_log = []
      @request_listeners = []
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)
      test_request = TestRequest.new(
        request,
        request.path,
        request.request_method_symbol,
        request.body.read
      )
      request.body.rewind

      @request_listeners.each do |listener|
        listener.process_request test_request
      end

      @debug_log << test_request if debug

      @app.call(env)
    end

    def has_received_post_request?(*models)
      @request_listeners << SingleRequestListener.new(models)
    end

    def verify
      @request_listeners.each do |listener|
        listener.receives_request?
      end

      @request_listeners.clear
    end

    class SingleRequestListener
      include RSpec::Matchers
      include JsonSpec::Matchers

      def initialize(models)
        @models = models
        @requests = SizedQueue.new(1)
      end

      def process_request(request)
        @requests << request if resource.location == request.path
      end

      def receives_request?
        request = request(timeout: 5)
        # TODO: more descriptive failure, i.e. expected models, but got nothing,
        expect(request).not_to be_nil, "No request for #{resource.location}"

        # expecting json request, otherwise shows what was that
        expect { JSON.parse(request.body) }.to_not raise_error, request.body
        expect(request.body).to be_json_eql resource.payload
        expect(request.path).to eq resource.location
        expect(request.method).to eq :post
      end

      def resource
        @resource ||= RichAndRestfulTests::Resource.new @models
      end

      private

      def request(timeout:)
        request = nil
        Thread.new { request = @requests.pop }.join timeout
        request
      end
    end
  end
end
