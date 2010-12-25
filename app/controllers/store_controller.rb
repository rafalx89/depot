class StoreController < ApplicationController
  def index
        @products = Product.find_products_for_sale
        @t=Time.now
        @time = @t.strftime("%Y-%m-%d %H:%M:%S")
  end

end
