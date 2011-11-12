# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

task :test do
  Dir['test_data/*'].each do |filename|
    ruby "unshred.rb #{filename}"
    sh "open output.png"
  end
end

task :default => :test