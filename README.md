# O2webappizer

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/o2webappizer`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Install the gem:

    $ gem install o2webappizer

To output the current gem version:

    $ o2webappizer -v


## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Vagrant

Add `192.168.33.37   app-name.dev` to your `/etc/hosts` file.
After `vagrant up`, connect with `vagrant ssh` and add your public ssh key `id_rsa.pub` to `~/.ssh/authorized_keys`.

## TODO

* Gzip yaml_db
* Moneybird i18n-workflow
* Rack-attack + Log rotate
* Devise Confirmed At option
* Rspec
* Redis + Que
* Solidus plugins (CMSConnector, EasyPost, Mini-cart, Wishlist, Volume Pricing, Custom Promos, Related Products, Variant Options, Reviews, Auctions)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/o2webappizer.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

