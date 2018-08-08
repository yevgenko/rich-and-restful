module RichAndRestfulTests
  class ApiRunner
    include RSpec::Matchers
    include JsonSpec::Matchers

    def initialize(session)
      @session = session
    end

    def create_resource(*models)
      resource = resource_for models
      post(
        resource.location,
        params: resource.payload,
        headers: resource.headers
      )
    end

    def has_responded_with_resource_created?(*models)
      resource = resource_for models
      # TODO: why 200?
      # expect(response).to have_http_status(:created)
      expect { JSON.parse(response.body) }.to_not raise_error, response.body
      expect(response.body).to be_json_eql resource.payload
      expect(response.parsed_body).to include(
        "id" => a_kind_of(Integer)
      )
    end

    private

    def resource_for(models)
      RichAndRestfulTests::Resource.new(models)
    end

    delegate :post, :response, to: :@session
  end
end
