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

    it 'should raise ResponseError for a 400 whose error message is not specially handled' do
      response = { status: '400', body: { error: 'Some other validation error' }.to_json }

      expect { subject.on_complete(response) }
        .to(raise_error(ActionNetworkRest::Response::ResponseError, /Some other validation error/))
    end

    it 'should raise AuthorizationError if status is 403' do
      response = { status: '403', body: { error: 'API Key invalid or not present' }.to_json }

      expect { subject.on_complete(response) }
        .to(raise_error(ActionNetworkRest::Response::AuthorizationError, /API Key invalid/))
    end

    it 'should raise NotFoundError if status is 404' do
      response = { status: '404', body: { error: 'Not found' }.to_json }

      expect { subject.on_complete(response) }.to raise_error(ActionNetworkRest::Response::NotFoundError, /Not found/)
    end

    it 'should raise TooManyRequests if status is 429' do
      response = { status: '429', body: { error: 'Too many requests' }.to_json }

      expect do
        subject.on_complete(response)
      end.to raise_error(ActionNetworkRest::Response::TooManyRequests, /Too many requests/)
    end

    %w[500 502 503].each do |server_error_code|
      it "should raise ServerError for server error with status #{server_error_code}" do
        response = { status: server_error_code, body: { error: 'Something went wrong' }.to_json }

        expect { subject.on_complete(response) }
          .to(raise_error(ActionNetworkRest::Response::ServerError, /Something went wrong/))
      end
    end

    it 'ServerError should be a ResponseError so existing rescues still catch 5xx' do
      response = { status: '500', body: { error: 'Something went wrong' }.to_json }

      expect { subject.on_complete(response) }
        .to(raise_error(ActionNetworkRest::Response::ResponseError))
    end

    it 'should raise ResponseError for a generic client error with status 418' do
      response = { status: '418', body: { error: 'Something went wrong' }.to_json }

      expect { subject.on_complete(response) }
        .to(raise_error(ActionNetworkRest::Response::ResponseError, /Something went wrong/))
    end
  end
end
