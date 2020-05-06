module ActionNetworkRest
  class Tags < Base
    attr_accessor :tag_id

    # Without a tag_id, this class is used for the Tag creation endpoint.
    # With a tag_id, this class is used to initialise the Taggings class,
    # like client.tags(123).taggings
    def initialize(tag_id=nil, client:)
      super(client: client, tag_id: tag_id)
    end

    def taggings
      @_taggings ||= ActionNetworkRest::Taggings.new(client: client, tag_id: tag_id)
    end

    def base_path
      'tags/'
    end

    def create(name)
      post_body = {name: name}
      response = client.post_request base_path, post_body
      object_from_response(response)
    end

    private

    def osdi_key
      'osdi:tags'
    end
  end
end
