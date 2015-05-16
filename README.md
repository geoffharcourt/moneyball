# Moneyball

Moneyball parses MLB Gameday's play-by-play information to pull useful
quantitative and qualitative information out of the data feed. Moneyball can
determine where a batted ball was hit, the general classification of the batted
ball, and stat line information from the plate appearance.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'moneyball'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moneyball

## Usage

`Moneyball::Parser` takes a Nokogiri XML node.

```ruby
raw_xml = '<atbat event="Strikeout" des="Ty Cobb strikes out swinging."></atbat>'
nokogiri_node = Nokogiri::XML(raw_xml).search("atbat").first
stats = Moneyball::Parser.new(nokogiri_node).stats

stats.slice(:pa, :ab, :h, :k) # => { pa: 1, ab: 1, h: 0, k: 1 }
```

`Moneyball::BattedBallLocationExtractor` and `Moneyball::BattedBallTypeExtractor` take a string from the play-by-play summary.

```ruby
summary = "Billy Hamilton hits a fly ball home run (22) to deep center field."
Moneyball::BattedBallTypeExtractor.new(summary).categorize # => "Line drive"
Moneyball::BattedBallLocationExtractor.new(summary).categorize # => "CF"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

This is a work in progress! I have been using pieces of this code in private projects, but it's time for the saber community to get a crack at improving this code.

Any contributions should come with tests (we use RSpec) and a well documented PR. If you have a specific event from the Gameday feed that prompted your pull request, please reference it in your PR.

Here's how to contribute!
1. Fork it ( https://github.com/[my-github-username]/moneyball/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License
Moneyball is © 2015 Geoff Harcourt. It is free software, and may be redistributed under the terms specified in the LICENSE file.
