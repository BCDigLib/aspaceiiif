# aspaceiiif

Generates IIIF manifests and Mirador viewer HTML from an ArchivesSpace digital 
object record. This gem is configured to support Boston College's IIIF implementation.

## Installation

To use the command line tool you will need to install locally. Clone or download 
this repository:

    $ git clone https://github.com/BCDigLib/aspace-to-iiif
    $ cd aspace-to-iiif

Update the settings in config.yml according to your ArchivesSpace instance, then 
build and install the gem:

    $ gem build aspaceiiif.gemspec
    $ gem install aspaceiiif-x.x.x.gem
    
## Usage

To generate a manifest and HTML view file for a single digital object, pass the 
digital object ID as an argument; e.g.:

    $ aspaceiiif 1596

To generate manifests and HTML view files for multiple digital objects, put the 
digital object IDs in a text file delimited by newlines, then pass that file as an 
argument; e.g.:

    $ aspaceiiif dig-obj-ids.txt

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