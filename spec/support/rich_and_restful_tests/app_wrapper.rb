module RichAndRestfulTests
  class AppWrapper
    TestRequest = Struct.new :request, :path, :method, :body

    attr_reader :debug_log
    attr_accessor :debug

    def initialize(app)
      @debug = false
      @debug_log = []
      @requests_queues = []
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)

      if queue = queue_for(request)
        queue << TestRequest.new(
          request,
          request.path,
          request.request_method_symbol,
          request.body.read
        )
        request.body.rewind
      end

      if debug
        @debug_log << TestRequest.new(
          request,
          request.path,
          request.request_method_symbol,
          request.body.read
        )
        request.body.rewind
      end

      @app.call(env)
    end

    def queue_for(request)
      @requests_queues.detect{ |queue| queue.resource.location == request.path }
    end

    def has_received_post_request?(*models)
      @requests_queues << SingleRequestQueue.new(models)
    end

    def verify
      @requests_queues.each do |queue|
        queue.has_a_request?
      end

      @requests_queues.clear
    end

    class SingleRequestQueue < SizedQueue
      include RSpec::Matchers
      include JsonSpec::Matchers

      def initialize(models)
        @models = models
        super(1)
      end

      def has_a_request?
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
        Thread.new { request = pop }.join timeout
        request
      end
    end
  end
end
