require 'spec_helper'

describe ActionNetworkRest::Client do
  describe 'initialization' do
    let(:api_key) { 'abcde12345' }

    it 'should turn an api_key option into an additional header' do
      client = ActionNetworkRest::Client.new(api_key: api_key)
      expect(client.default_options[:additional_headers]).to eq({'OSDI-API-Token' => api_key})
    end
  end

  describe '.people' do
    subject { ActionNetworkRest::Client.new }

    specify { expect(subject.people).to be_a ActionNetworkRest::People }
  end

  describe '.petitions' do
    subject { ActionNetworkRest::Client.new }

    it 'should work without a petition_id' do
      expect(subject.petitions).to be_a ActionNetworkRest::Petitions
    end

    it 'should work with a petition_id' do
      expect(subject.petitions(123)).to be_a ActionNetworkRest::Petitions
    end
  end
end
