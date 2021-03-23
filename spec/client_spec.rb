# frozen_string_literal: true

require 'spec_helper'

describe ActionNetworkRest::Client do
  describe 'initialization' do
    let(:api_key) { 'abcde12345' }

    it 'should turn an api_key option into an additional header' do
      client = ActionNetworkRest::Client.new(api_key: api_key)
      expect(client.default_options[:additional_headers]).to eq({ 'OSDI-API-Token' => api_key })
    end
  end

  describe '.people' do
    subject { ActionNetworkRest::Client.new }

    specify { expect(subject.people).to be_a ActionNetworkRest::People }
  end

  describe '.petitions' do
    subject { ActionNetworkRest::Client.new }

    it 'should work without a petition_id' do
      p = subject.petitions
      expect(p).to be_a ActionNetworkRest::Petitions
      expect(p.petition_id).to be_nil
    end

    it 'should work with a petition_id' do
      p = subject.petitions(123)
      expect(p).to be_a ActionNetworkRest::Petitions
      expect(p.petition_id).to eq 123
    end

    it 'should work with two calls in a row with different arguments' do
      p = subject.petitions
      expect(p).to be_a ActionNetworkRest::Petitions
      expect(p.petition_id).to be_nil
      p = subject.petitions(123)
      expect(p).to be_a ActionNetworkRest::Petitions
      expect(p.petition_id).to eq 123
    end
  end

  describe '.tags' do
    subject { ActionNetworkRest::Client.new }

    it 'should work without a tag_id' do
      p = subject.tags
      expect(p).to be_a ActionNetworkRest::Tags
      expect(p.tag_id).to be_nil
    end

    it 'should work with a tag_id' do
      p = subject.tags(123)
      expect(p).to be_a ActionNetworkRest::Tags
      expect(p.tag_id).to eq 123
    end

    it 'should work with two calls in a row with different arguments' do
      p = subject.tags
      expect(p).to be_a ActionNetworkRest::Tags
      expect(p.tag_id).to be_nil
      p = subject.tags(123)
      expect(p).to be_a ActionNetworkRest::Tags
      expect(p.tag_id).to eq 123
    end
  end
end
