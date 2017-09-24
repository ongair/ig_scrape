# IG_Scrape

This gem provides a utility for scraping instagram posts and comments

## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'ig_scrape'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ig_scrape

## Usage

### Getting information about an Instagram account

  ```ruby
    require 'ig_scrape'

    client = IGScrape::Client.new("username")
    puts client.follower_count
    puts client.follows_count
    puts client.post_count
  ```

### Loading all the posts for an instagram account  

  ```ruby
    require 'ig_scrape'
    client = IGScrape::Client.new("username")
    client.load

    puts client.posts.length == client.post_count
  ```

### Loading a post

  ```ruby
    require 'ig_scrape'
    code = "KVHudYDs"
    post = IGScrape::Post.load_from_shortcode(code)
    puts post.comment_count
    puts post.has_more_comments?

    post.load_more_comments
    puts post.has_more_comments?
  ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ongair/ig_scrape.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
