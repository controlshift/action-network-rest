# frozen_string_literal: true

require 'spec_helper'

describe ActionNetworkRest::Response::RaiseError do
  describe '#on_complete' do
    it 'should not raise if status is 200' do
      expect { subject.on_complete(status: '200') }.not_to raise_error
    end

    it 'should raise MustSpecifyValidPersonId if status is 400 and error message refers to person id' do
      response = { status: '400', body: { error: 'You must specify a valid person id' }.to_json }

      expect { subject.on_complete(response) }
        .to(raise_error(ActionNetworkRest::Response::MustSpecifyValidPersonId, /You must specify a valid person id/))
    end

    it 'should raise NotFoundError if status is 404' do
      response = { status: '404', body: { error: 'Not found' }.to_json }

      expect { subject.on_complete(response) }.to raise_error(ActionNetworkRest::Response::NotFoundError, /Not found/)
    end

    %w[418 500].each do |generic_error_code|
      it "should raise ResponseError for generic error with status #{generic_error_code}" do
        response = { status: generic_error_code, body: { error: 'Something went wrong' }.to_json }

        expect { subject.on_complete(response) }
          .to(raise_error(ActionNetworkRest::Response::ResponseError, /Something went wrong/))
      end
    end
  end
end
