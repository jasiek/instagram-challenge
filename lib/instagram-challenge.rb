require 'rubygems'
require 'bundler'
Bundler.require

include Magick

class Stripe
  attr_reader :image

  EXTRACTOR_LAMBDA = lambda do |p|
    p.intensity
  end

  def initialize(image)
    @image = image
  end

  def left_vector
    @left_vector ||= @image.get_pixels(0, 0, 1, @image.rows).map(&EXTRACTOR_LAMBDA)
  end

  def right_vector
    @right_vector ||= @image.get_pixels(31, 0, 1, @image.rows).map(&EXTRACTOR_LAMBDA)
  end

  def distance(other)
    self.class.distance(self.right_vector, other.left_vector)
  end

  def self.distance(v1, v2)
    raise unless v1.size == v2.size
    d = 0.0
    for i in 0...v1.size do
      d += (v1[i] - v2[i]) ** 2
    end
    Math.sqrt(d)
  end
end

def generate_stripes(image)
  height = image.rows
  stripes = []
  (0...(image.columns)).step(32) do |x|
    stripes << Stripe.new(image.crop(x, 0, 32, height))
  end
  stripes
end

img = Image.read('TokyoPanoramaShredded.png').first
stripes = generate_stripes(img)

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
img2.write('output.png')

