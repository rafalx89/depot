class StoreController < ApplicationController
        before_filter :find_cart, :except => :empty_cart
  def index
        @products = Product.find_products_for_sale
        @counter = increment_count
        respond_to do |format|
                format.html
                format.xml {render :layout => false} 
        end
  end
  def add_to_cart
          product = Product.find(params[:id])
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

  def checkout
          @spr_checkout = true
          if @cart.items.empty?
                  redirect_to_index("Your cart is empty")
          else
                  @order = Order.new
          end
  end
  def save_order
          @order = Order.new(params[:order])
          @order.add_line_items_from_cart(@cart)
          if @order.save
                  session[:cart]=nil
                  @spr_checkout = nil
                  redirect_to_index(I18n.t('flash.thanks'))
          else
                  @spr_checkout = true
                  render :action => 'checkout'
          end
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
          @current_item = @cart.subb_product(product)
          respond_to do |format|
                  format.js if request.xhr?
                  format.html{redirect_to_index}
          end
        end
  end
  protected 
  def authorize
  end


  private 

  def find_cart
         @cart = (session[:cart] ||=Cart.new)
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
