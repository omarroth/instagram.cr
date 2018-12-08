# instagram.cr

Crystal library for crawling Instagram.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  instagram:
    github: omarroth/instagram.cr
```

## Usage

```crystal
require "instagram"

end_cursor = nil
(1..Float64::INFINITY).each do |i|
  user = Instagram.get_user_page("natgeo", end_cursor)
  end_cursor = user["edge_owner_to_timeline_media"]["page_info"]["end_cursor"].as_s?
  has_next_page = user["edge_owner_to_timeline_media"]["page_info"]["has_next_page"].as_bool

  File.write("#{i}.json", user.to_pretty_json)
  print "Page : #{i}\r"

  if !has_next_page
    break
  end
end
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/omarroth/instagram.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Omar Roth](https://github.com/omarroth) - creator and maintainer
