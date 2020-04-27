require 'spec_helper'

describe ActionNetworkRest::Client do
  let(:api_key) { 'abcde12345' }

  it 'should turn an api_key option into an additional header' do
    client = ActionNetworkRest::Client.new(api_key: api_key)
    expect(client.default_options[:additional_headers]).to eq({'OSDI-API-Token' => api_key})
  end
end
