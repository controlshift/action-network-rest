module ActionNetworkRest
  class Petitions < Base
    attr_accessor :petition_id

    # Without a petition_id, this class is used for Petition creation/update endpoints.
    # With a petition_id, this class is used to initialise the Signatures class,
    # like client.petitions(123).signatures
    def initialize(petition_id=nil, client:)
      super(client: client, petition_id: petition_id)
    end

    def signatures
      @_signatures ||= ActionNetworkRest::Signatures.new(client: client, petition_id: petition_id)
    end

    def base_path
      'petitions/'
    end

    def create(petition_data, creator_person_id: nil)
      post_body = petition_data
      if creator_person_id.present?
        creator_person_url = action_network_url("/people/#{url_escape(creator_person_id)}")
        post_body['_links'] = {'osdi:creator' => {href: creator_person_url}}
      end

      response = client.post_request base_path, post_body
      object_from_response(response)
    end

    def update(id, petition_data)
      petition_path = "#{base_path}#{url_escape(id)}"
      response = client.put_request petition_path, petition_data
      object_from_response(response)
    end

    private

    def osdi_key
      'osdi:petitions'
    end
  end
end
