# frozen_string_literal: true

def fixture_path
  File.expand_path('fixtures', __dir__)
end

def fixture(file)
  File.new(File.join(fixture_path, '/', file))
end
