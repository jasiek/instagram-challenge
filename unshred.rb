require 'rubygems'
require 'bundler'
Bundler.require
$: << '.' unless $:.include?('.')
require 'common'
require 'stripe'

include Magick

raise ArgumentError unless not ARGV.empty?

def unshred(image)
  stripes = generate_stripes(image).map do |img|
    Stripe.new(img)
  end

  fit = [stripes.shift]

  while ! stripes.empty?
    fitted_left = fit.first
    fitted_right = fit.last

    min = 1.0/0
    min_cand = nil
    min_dir = nil
    
    stripes.each do |cand|
      d = cand.distance(fitted_left)
      if d < min
        min = d
        min_cand = cand
        min_dir = :left
      end
      d = fitted_right.distance(cand)
      if d < min
        min = d
        min_cand = cand
        min_dir = :right
      end
    end
    
    case min_dir
    when :left
      fit.unshift(min_cand)
      stripes.delete(min_cand)
    when :right
      fit.push(min_cand)
      stripes.delete(min_cand)
    end
  end

  ilist = ImageList.new
  fit.each do |stripe|
    ilist << stripe.image
  end
  img2 = ilist.append(false)
end


image = Image.read(filename = ARGV.shift).first
unshred(image).write('output.png')



