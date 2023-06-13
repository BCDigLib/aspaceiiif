# aspaceiiif

Generates IIIF JSON manifests and HTML files instantiating Mirador (locally termed
'views') from an ArchivesSpace digital object record. This gem is configured to
support Boston College Libraries' IIIF implementation.

## Installation

This gem requires Ruby v2.6.10 or below.

To use the command line tool you will need to install locally. First, make sure any old versions of the gem have been removed:

    $ gem uninstall aspaceiiif

Clone or download this repository:

    $ git clone https://github.com/BCDigLib/aspaceiiif
    $ cd aspaceiiif

Make a copy of _example_config.yml_ named _config.yml_:

    $ cp example_config.yml config.yml
   
Edit _config.yml_ according to your ArchivesSpace instance. Add the changes to Git (this is necessary
 because the gemspec uses git ls-files):

    $ git add .

Install required gems:

    $ bundle install

You can now build and install the gem:

    $ gem build aspaceiiif.gemspec
    $ gem install aspaceiiif-0.3.1.gem

## Usage

To generate a manifest and view for a single digital object, pass
'digital_object' and the digital object ID as arguments; e.g.:

    $ aspaceiiif digital_object 1596

The gem can also generate manifests and views for all digital objects associated
with a resource record. To do this, pass 'resource' as the resource ID as
arguments, e.g.:

    $ aspaceiiif resource 166

In either case, the gem will create two directories -- 'manifests' and 'view' --
where it will write the output files.

## Development

After checking out the repo, run `bundle exec rspec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git
commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/aspaceiiif.
This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
