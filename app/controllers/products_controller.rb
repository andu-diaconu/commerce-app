class ProductsController < ApplicationController
  include Pagy::Backend


  def create
    redirect_to root_path, :flash => {alert: "Forbbiden!"} if current_user.nil? || current_user.client?
    params[:stock] = 0 if params[:stock].to_i < 0
    @product = Product.new(
      name: params[:name],
      description: params[:description],
      price: params[:price].to_d,
      stock: params[:stock].to_i,
      image: params["image-upload"],
      rating: 0,
      rating_count: 0,
      brand_id: current_user.brand.id,
      identifier: ('A'..'Z').to_a.sample(6).join
    )

    if @product.save
      redirect_to product_path(@product), :flash => {notice: "Product created successfully!"}
    else
      respond_to do |format|
        format.html{
          flash.now[:alert] = @product.errors.full_messages.join("<br/>".html_safe)
          render :index
        }
      end  
    end
  end

  def index
    products = Product.where(hidden: false).where.not(image: nil)
    
    if current_user.present? && current_user.role == "Staff"
      brand = Brand.find_by(name: current_user.brand.name).id
      products = products.where(brand_id: brand)
    end

    if params[:search].present?
      products = products.where("name ILIKE ?", "%#{params[:search]}%")
    end

    if params[:category].present?
      category = Category.find_by(name: params[:category])
      pis = category.product_categories.pluck(:product_id)
      products = products.where(id: pis)
    end

    if params[:brand].present?
      brand = Brand.find_by(name: params[:brand]).id
      products = products.where(brand_id: brand)
    end
    
    if params[:rating].present?
      products = products.where("(rating <= ?) AND (rating >= ?)", params[:rating].to_f + 0.5, params[:rating].to_f - 0.5)
    end

    if params[:price].present?
      case params[:price].to_i
      when 100
        products = products.where("price >= 0 AND price <=200")
      when 350
        products = products.where("price >= 200 AND price <= 500")
      when 650
        products = products.where("price >= 500 AND price <= 800")
      when 900
        products = products.where("price >= 800 AND price <= 1000")
      when 1000
        products = products.where("price >= 1000")
      end
    end

    if params[:stock_toggle_value].present?
      if params[:stock_toggle_value] == "off"
        products = products.where("stock > 0")
      end
    end

    if params[:favorites_only].present?
      if current_user.nil? || current_user.role == "Staff"
        redirect_to root_path, :flash => {alert: "Forbbiden!"}
        return
      end
      favorites = Favorite.where(user_id: current_user.id).pluck(:product_id)
      products = products.where(id: favorites)
    end

    @favorites = []
    if current_user.present?
      @favorites = Favorite.where(user_id: current_user.id).pluck(:product_id)
    end

    @pagy, @products = pagy(products, items: 9)
  end

  def show
    @product = Product.find(params[:id])
    @products = []
    if current_user.nil? || current_user.client?
      o_ids = @product.product_orders.pluck(:order_id)
      o = Order.where(id: o_ids).where.not(user_id: nil).first
      ec = EncodedUser.where("value ILIKE ?", "%#{o.user.identifier}%").first
      puts "-----"
      puts "#{ec}"
      recommends = ec.call_adshopping_ai
      identifiers = []
      if recommends.present?
        recommends.each do |r|
          if r["Score"] > 0.2 && r["Identifier"] != @product.identifier
            identifiers << r["Identifier"]
          end
        end
        results = Product.where.not(image: nil).where(identifier: identifiers).first(3)
        @products = results || nil
      else
        @products = nil
      end
    end

    redirect_back fallback_location: root_path, :flash => {alert: "This product has been removed from the app!"} if @product.hidden
    @favorite = Favorite.find_by(user_id: current_user.id, product_id: @product.id) if current_user.present?
    @allow_rating = false
    if current_user.present? && current_user.client?
      orders = current_user.orders.pluck(:id)
      products = ProductOrder.where(order_id: orders).pluck(:product_id)
      if products.include?(@product.id) && UserRating.find_by(product_id: @product.id, user_id: current_user.id).nil?
        @allow_rating = true
      end
    end
  end

  def update
    @product = Product.find(params[:id])
    if current_user.nil? || !current_user.staff?  || @product.brand_id != current_user.brand.id
      redirect_to root_path, :flash => {alert: "Forbbiden!"}
      return
    end

    @product = Product.find(params[:id])
    if params["hidden"].present? && current_user.present? && current_user.staff?
      @product.update(hidden: true)
      redirect_to products_path, :flash => {notice: "Product has been removed!"}
      return
    end

    params[:stock] = 0 if params[:stock].to_i < 0
    @product.update(
      name: params[:name],
      description: params[:description],
      price: params[:price].to_d,
      stock: params[:stock].to_i,
    )
    @product.update(image: params["upload-image"]) if params["upload-image"].present?

    queued= Customer.where(product_id: @product.id, done: false)
    if queued.count > 0 && params[:stock].to_i > 0
      queued.each do |q|
        ProductMailer.back_in_stock(q.product_id, q.user_id).deliver_now
      end
      queued.update_all(done: true)
    end

    redirect_back fallback_location: root_path, :flash => {notice: "Product has been updated!"}
  end

  def edit
    @product = Product.find(params[:id])
  end

  def receive_rating
    if current_user.nil? || !current_user.client? || UserRating.find_by(product_id: params[:id].to_i, user_id: current_user.id).present?
      redirect_to root_path, :flash => {alret: "Forbbiden!"} 
      return
    else
      @product = Product.find(params[:id])
      rating_count = @product.rating_count + 1
      rating_sum = @product.rating_sum + params[:rating].to_i
      rating = (rating_sum.to_d / rating_count).to_d.round(2)
      @product.update(rating: rating, rating_count: rating_count, rating_sum: rating_sum)
      UserRating.create(product_id: @product.id, user_id: current_user.id, value: params[:rating].to_i)
      redirect_back fallback_location: root_path, :flash => {notice: "Your rating has been processed!"}
    end
  end
end
