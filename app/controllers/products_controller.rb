class ProductsController < ApplicationController
end

class ProductsController < ApplicationController
  def new
  end

  def create
    product_name = params[:product_name]
    generate_image(product_name)
  end

  private

  def generate_image(product_name)
    image = ChunkyPNG::Image.new(200, 200, ChunkyPNG::Color.rgb(0, 0, 0))
    text = product_name || 'Default Product'
    image.compose!('text', x: 50, y: 80, text: text, font: 20)
    image.save("public/#{text.downcase.gsub(' ', '_')}.png")

    redirect_to root_path, notice: 'Image generated successfully!'
  end
end

