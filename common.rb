def generate_stripes(image)
  height = image.rows
  stripes = []
  (0...image.columns).step(32) do |x|
    stripes << image.crop(x, 0, 32, height)
  end
  stripes
end
