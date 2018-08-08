module RichAndRestfulTests
  class RestClient
    def initialize(session)
      @session = session
    end

    def make_request(*resources)
      resource = Resource.new(*resources)

      @session.post(
        resource.location,
        params: resource.payload,
        headers: resource.headers
      )

      resource.payload # request body
    end
  end
end
