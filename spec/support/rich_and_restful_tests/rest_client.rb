module RichAndRestfulTests
  module RestClient
    def create_resource(*models)
      resource = resource_for models
      post(
        resource.location,
        params: resource.payload,
        headers: resource.headers
      )
    end

    def has_received_created_resource?(*models)
      resource = resource_for models
      # TODO: why 200?
      # expect(response).to have_http_status(:created)
      expect { JSON.parse(response.body) }.to_not raise_error, response.body
      expect(response.body).to be_json_eql resource.payload
      expect(parse_json(response.body)).to include(
        "id" => a_kind_of(Integer)
      )
    end

    def resource_for(models)
      RichAndRestfulTests::Resource.new(models)
    end
  end
end
