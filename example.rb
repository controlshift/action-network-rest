require_relative 'lib/action_network_rest'
require 'dotenv'
require 'byebug'

Dotenv.load('.env')
raise 'Must set API_KEY environmental variable. See .env.sample for details' if ENV['API_KEY'].nil?

client = ActionNetworkRest.new(api_key: ENV['API_KEY']) # rubocop:disable Lint/UselessAssignment

puts "Ready to call Action Network API using 'client' object"
byebug # rubocop:disable Lint/Debugger

puts "Bye!"
