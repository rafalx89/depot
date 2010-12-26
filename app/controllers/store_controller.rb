class StoreController < ApplicationController
  def index
        @products = Product.find_products_for_sale
        @counter = increment_count
        @cart = find_cart
       # @t=Time.now
       # @time = @t.strftime("%Y-%m-%d %H:%M:%S")
  end
  def add_to_cart
          product = Product.find(params[:id])
          @cart = find_cart
          session[:count]=0 # zerowanie liczby wejsc na strone 
          @current_item = @cart.add_product(product)
          respond_to do |format|
                  format.js if request.xhr?
                  format.html{redirect_to_index}
          end
  rescue ActiveRecord::RecordNotFound
          logger.error("Attempt to access i nvalid product #{params[:id]}")
          redirect_to_index("Invalid product")
  end

  def empty_cart
          session[:cart]=nil
          
          respond_to do |format|
                  format.js if request.xhr?
                  format.html{redirect_to_index}
          end
  end
  def delete_from_cart
        begin
          product = Product.find(params[:id])
        rescue ActiveRecord::RecordNotFound
                logger.error("Attempt to access invalid product #{params[:id]}")
                redirect_to_index
        else
          @cart = find_cart
          @current_item = @cart.subb_product(product)
          respond_to do |format|
                  format.js if request.xhr?
                  format.html{redirect_to_index}
          end
        end
  end

private 

  def find_cart
          session[:cart] ||=Cart.new
  end

  def redirect_to_index(msg = nil)
          flash[:notice] = msg if msg
          redirect_to :action => 'index'
  end
  def increment_count
          session[:count] ||=0
          session[:count] +=1
  end

end
