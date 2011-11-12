require 'rubygems'
require 'bundler'
Bundler.require
$: << '.' unless $:.include?('.')
require 'common'

include Magick

raise ArgumentError unless not ARGV.empty?

def shred(image)
  ilist = ImageList.new
  generate_stripes(image).shuffle.each do |image|
    ilist << image
  end
  img = ilist.append(false)
end

shred(Image.read(filename = ARGV.shift).first).write(filename)

