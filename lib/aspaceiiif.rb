require 'aspaceiiif/version'
require 'aspaceiiif/builder'
require 'aspaceiiif/view_builder'
require 'aspaceiiif/fetch_records'
require 'optparse'

module ASpaceIIIF
  def self.run
    ARGV << "-h" if ARGV.empty? || (ARGV[0] != "digital_object" && ARGV[0] != "resource")

    OptionParser.new do |parser|
      parser.banner = "Usage: aspaceiiif [ resource | digital_object ] [ id (db primary key) ] e.g., aspaceiiif resource 15"

      parser.on("-h", "--help", "Show this help message") do |p|
        puts parser
        exit
      end
    end.parse!

    Dir.mkdir('manifests') unless File.exists?('manifests')
    Dir.mkdir('view') unless File.exists?('view')
    Dir.mkdir('logs') unless File.exists?('logs')

    fetch_records = ASpaceIIIF::FetchRecords.new(ARGV)
    fetch_records.run
  end
end
