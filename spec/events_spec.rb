# frozen_string_literal: true

require 'spec_helper'

describe ActionNetworkRest::Events do
  let(:api_key) { 'secret_key' }

  subject { ActionNetworkRest.new(api_key: api_key) }

end
