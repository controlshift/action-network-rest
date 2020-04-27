# ActionNetworkRest

Ruby client for interacting with the [ActionNetwork REST API](https://actionnetwork.org/docs/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'action_network_rest'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action_network_rest

## Usage

```
client = ActionNetworkRest.new(api_key: YOUR_API_KEY)
person = client.person.get(person_actionnetwork_identifier)
puts person.email_addresses
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/controlshift/action-network-rest. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActionNetworkRest project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/controlshift/action-network-rest/blob/master/CODE_OF_CONDUCT.md).
