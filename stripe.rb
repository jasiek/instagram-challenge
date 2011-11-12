class Stripe
  attr_reader :image

  EXTRACTOR_LAMBDA = lambda do |p|
    h, s, l, a = p.to_hsla
    Math.sqrt(s) + l / 10
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
      d += (v1[i] - v2[i]).abs
    end
    Math.sqrt(d)
  end
end
