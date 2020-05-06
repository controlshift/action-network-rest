require 'spec_helper'

describe ActionNetworkRest::Tags do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

  describe '#get' do
    let(:tag_id) { '71f8feef-61c8-4e6b-9745-ec1d7752f298' }
    let(:tag_name) { 'Volunteers' }
    let(:response_body) do
      {
        identifiers: ["action_network:#{tag_id}"],
        name: tag_name
      }.to_json
    end

    before :each do
      stub_actionnetwork_request("/tags/#{tag_id}", method: :get)
        .to_return(status: 200, body: response_body)
    end

    it 'should retrieve tag data' do
      tag = subject.tags.get(tag_id)
      expect(tag.name).to eq tag_name
    end
  end

  describe '#list' do
    let(:response_body) do
      {
        _embedded: {
          'osdi:tags' => [
            { identifiers: [ 'action_network:fc0a1ec6-5743-4b98-ae0c-cea8766b2212' ], name: 'Economic Justice' },
            { identifiers: [ 'action_network:71f8feef-61c8-4e6b-9745-ec1d7752f298' ], name: 'Volunteers' }
          ]
        }
      }.to_json
    end

    context 'requesting first page' do
      before :each do
        stub_actionnetwork_request("/tags/?page=1", method: :get)
          .to_return(status: 200, body: response_body)
      end

      it 'should retrieve the tags data from first page when calling without an argument' do
        tags = subject.tags.list

        expect(tags.count).to eq 2
        expect(tags.first.action_network_id).to eq 'fc0a1ec6-5743-4b98-ae0c-cea8766b2212'
        expect(tags.first.name).to eq 'Economic Justice'
        expect(tags.last.action_network_id).to eq '71f8feef-61c8-4e6b-9745-ec1d7752f298'
        expect(tags.last.name).to eq 'Volunteers'
      end

      it 'should retrieve the tags data from first page when calling with page argument' do
        tags = subject.tags.list(page: 1)

        expect(tags.count).to eq 2
        expect(tags.first.action_network_id).to eq 'fc0a1ec6-5743-4b98-ae0c-cea8766b2212'
        expect(tags.first.name).to eq 'Economic Justice'
        expect(tags.last.action_network_id).to eq '71f8feef-61c8-4e6b-9745-ec1d7752f298'
        expect(tags.last.name).to eq 'Volunteers'
      end
    end

    context 'requesting page 10' do
      before :each do
        stub_actionnetwork_request("/tags/?page=10", method: :get)
          .to_return(status: 200, body: response_body)
      end

      it 'should retrieve the tags data from requested page number' do
        tags = subject.tags.list(page: 10)

        expect(tags.count).to eq 2
        expect(tags.first.action_network_id).to eq 'fc0a1ec6-5743-4b98-ae0c-cea8766b2212'
        expect(tags.first.name).to eq 'Economic Justice'
        expect(tags.last.action_network_id).to eq '71f8feef-61c8-4e6b-9745-ec1d7752f298'
        expect(tags.last.name).to eq 'Volunteers'
      end
    end
  end

  describe '#create' do
    let(:tag_name) { 'Volunteers' }
    let(:request_body) { {name: tag_name} }
    let(:tag_id) { '71f8feef-61c8-4e6b-9745-ec1d7752f298' }
    let(:response_body) do
      {
        identifiers: ["action_network:#{tag_id}"],
        name: tag_name
      }.to_json
    end
    let!(:post_stub) do
      stub_actionnetwork_request('/tags/', method: :post, body: request_body)
        .to_return(status: 200, body: response_body)
    end

    it 'should POST tag' do
      tag = subject.tags.create(tag_name)

      expect(post_stub).to have_been_requested

      expect(tag.action_network_id).to eq tag_id
    end
  end

  describe '#find_by_name' do
    before :each do
      stub_actionnetwork_request("/tags/?page=1", method: :get)
        .to_return(status: 200, body: response_body)
    end

    context 'no tags exist' do
      let(:response_body) { {}.to_json }

      it 'should return nil' do
        expect(subject.tags.find_by_name('foo')).to be_nil
      end
    end

    context 'multiple tags exist' do
      let(:response_body) do
        {
          _embedded: {
            'osdi:tags' => [
              { identifiers: [ 'action_network:fc0a1ec6-5743-4b98-ae0c-cea8766b2212' ], name: 'Economic Justice' },
              { identifiers: [ 'action_network:71f8feef-61c8-4e6b-9745-ec1d7752f298' ], name: 'Volunteers' }
            ]
          }
        }.to_json
      end

      it 'should return tag matching the name' do
        found_tag = subject.tags.find_by_name('Volunteers')

        expect(found_tag).not_to be_nil
        expect(found_tag.action_network_id).to eq('71f8feef-61c8-4e6b-9745-ec1d7752f298')
        expect(found_tag.name).to eq('Volunteers')
      end

      context 'no tag matching the name' do
        before :each do
          stub_actionnetwork_request("/tags/?page=2", method: :get)
            .to_return(status: 200, body: {}.to_json)
        end

        it 'should return nil if no tag matching the name is found' do
          found_tag = subject.tags.find_by_name('Foo')

          expect(found_tag).to be_nil
        end
      end
    end

    context 'tag is retrieved in second page' do
      let(:response_body) do
        {
          _embedded: {
            'osdi:tags' => [
              { identifiers: [ 'action_network:71f8feef-61c8-4e6b-9745-ec1d7752f298' ], name: 'Economic Justice' }
            ]
          }
        }.to_json
      end

      let(:second_page_response_body) do
        {
          _embedded: {
            'osdi:tags' => [
              { identifiers: [ 'action_network:71f8feef-61c8-4e6b-9745-ec1d7752f298' ], name: 'Volunteers' }
            ]
          }
        }.to_json
      end

      before :each do
        stub_actionnetwork_request("/tags/?page=2", method: :get)
          .to_return(status: 200, body: second_page_response_body)
      end

      it 'should return tag matching the name' do
        found_tag = subject.tags.find_by_name('Volunteers')

        expect(found_tag).not_to be_nil
        expect(found_tag.action_network_id).to eq('71f8feef-61c8-4e6b-9745-ec1d7752f298')
        expect(found_tag.name).to eq('Volunteers')
      end
    end
  end
end
