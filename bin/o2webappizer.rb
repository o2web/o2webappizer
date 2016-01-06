#!/usr/bin/env ruby
require 'pathname'

source_path = (Pathname.new(__FILE__).dirname + '../lib').expand_path
$LOAD_PATH << source_path

require 'o2webappizer'

if ['-v', '--version'].include? ARGV[0]
  puts O2webappizer::VERSION
  exit 0
end

templates_root = File.expand_path(File.join("..", "templates"), File.dirname(__FILE__))
O2webappizer::AppGenerator.source_root templates_root
O2webappizer::AppGenerator.source_paths << Rails::Generators::AppGenerator.source_root << templates_root

O2webappizer::AppGenerator.start
