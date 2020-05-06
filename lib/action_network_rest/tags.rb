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

    def find_by_name(name)
      # Action Network API doesn't support currently OData querying for tags
      # (https://actionnetwork.org/docs/v2#odata) so we need to retrieve a list of
      # all tags and iterate to find the one we're looking for.
      page = 1
      loop do
        tags = self.list(page: page)
        return nil if tags.empty?

        found_tag = tags.find { |t| t.name == name }
        return found_tag unless found_tag.nil?

        page += 1
      end
    end

    private

    def osdi_key
      'osdi:tags'
    end
  end
end
