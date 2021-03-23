# frozen_string_literal: true

# Only works in contexts where api_key is defined
def stub_actionnetwork_request(path, method:, body: nil)
  stub_request(method, "https://actionnetwork.org/api/v2#{path}")
    .with(body: body, headers: { 'OSDI-API-Token' => api_key })
end
