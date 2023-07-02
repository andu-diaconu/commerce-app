class CartsController < ApplicationController

  def create
    redirect_to root_path, :flash => {alert: "Forbbiden!"} if current_user.present? && current_user.staff?
    product_id = params[:product_id]
    quantity = params[:qty].to_i

    session[:cart] ||= {}
    session[:cart][product_id] = quantity

    redirect_back fallback_location: root_path, :flash => {notice: "Product added successfully to your cart!"}
  end


  def checkout_cart
    redirect_to root_path, :flash => {alert: "Forbbiden!"} if current_user.present? && current_user.staff?
    # session[:cart].delete("promo")
    if session[:cart].present?      
      @products = Product.where(id: session[:cart].keys)
      @subtotal = 0
      if @products.present?
        discount = Discount.find_by(brand_id: @products.first.brand_id, code: params[:promo_code])
        if @products.pluck(:brand_id).uniq.count == 1 && discount.present? && discount.expires_at > Time.now && session[:cart][:promo].nil?
          session[:cart]["promo"] = discount.value
          session[:discount_id] = discount.id
          redirect_back fallback_location: root_path, :flash => {notice: "Promo applied!"}
        end
        @products.each do |p|
          @subtotal += p.price * session[:cart]["#{p.id}"].to_i
        end
        @shipping = @subtotal > 150 ? 5 : 10
        @total = @subtotal + @shipping - session[:cart]["promo"].to_f
        @total = 0 if @total < 0
      end
      @checkout = true
      session[:cart].each do |k,v|
        if k != "#{:promo}"
          stock = Product.find(k).stock
          if stock < v.to_i
            @checkout = false
            next
          end
        end
      end
    end
  end

  def remove_item
    redirect_to root_path, :flash => {alert: "Forbbiden!"} if current_user.present? && current_user.staff?
    session[:cart].delete(params[:product_id])
    redirect_back fallback_location: root_path, :flash => { notice: "The product has been removed from your cart!" }
  end

  def update_qty
    redirect_to root_path, :flash => {alert: "Forbbiden!"} if current_user.present? && current_user.staff?
    session[:cart]["#{params[:product_id]}"] = params[:quantity]
    redirect_back fallback_location: root_path, :flash => { notice: "The quantity has been changed!" }
  end

  def empty_cart
    redirect_to root_path, :flash => {alert: "Forbbiden!"} if current_user.present? && current_user.staff?
    session[:cart] = nil
    session[:discount_id] = nil
    redirect_to products_path, :flash => {notice: "Your cart is empty now!"}
  end
end