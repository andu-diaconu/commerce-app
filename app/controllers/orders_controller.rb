class OrdersController < ApplicationController

  def index
    redirect_to root_path, :flash => {alert: "Forbbiden!"} if current_user.staff?
    @orders = Order.where(user_id: current_user.id).order(created_at: :desc)
  end

  def new
    redirect_to root_path, :flash => {alert: "Forbbiden!"} if current_user.present? && !current_user.client?
  end

  def create
    redirect_to root_path, :flash => {alert: "Forbbiden!"} if current_user.present? && !current_user.client?
    billing = BillingAddress.find_or_create_by(
      country: params["country-biling"],
      district: params["district-billing"],
      city: params["city-billing"],
      street: params["street-billing"],
      bl: params["bl-billing"],
      first_name: params["first-name-billing"],
      last_name: params["last-name-billing"],
      email: params["email-billing"],
      phone: params["phone-billing"]
    )

    shipping = ShippingAddress.find_or_create_by(
      country: params["country-shipping"],
      district: params["district-shipping"],
      city: params["city-shipping"],
      street: params["street-shipping"],
      bl: params["bl-shipping"],
      first_name: params["first-name-shipping"],
      last_name: params["last-name-shipping"],
      email: params["email-shipping"],
      phone: params["phone-shipping"]
    )

    if params["payment-method"] == "Credit Card"
      cc = CreditCard.find_or_create_by(
        card: params["card-type"],
        number: params["card-number"],
        month: params["expiration-month"],
        year: params["expiration-year"],
        cvv: params["cvv"],
        owner: params["cardholder-name"]
      )
    end

    id = current_user.id if current_user.present?
  
    @order = Order.create(subtotal: params["subtotal"].to_d, shipping_tax: params["shipping"].to_d, 
      discount_id: session["discount_id"].to_i, total: params["total"].to_d, payment_method: params["payment-method"], delivery_method: params["shipping-method"], user_id: (id rescue nil),
      billing_address_id: billing.id, shipping_address_id: shipping.id, credit_card_id: (cc.id rescue nil), invoice: "")

    session[:cart].each do |k,v|
      if k != "promo"
        product = Product.find(k.to_i)
        new_stock = product.stock - v.to_i
        product.update(stock: new_stock)
        ProductOrder.create(order_id: @order.id, product_id: product.id, quantity: v.to_i, price: product.price)
      end
    end

    require 'prawn'

    pdf = Prawn::Document.new
    pdf.move_down 20
    pdf.text 'Invoice', size: 24, style: :bold
    pdf.move_down 10
    pdf.text "Invoice Date: #{@order.created_at.strftime('%d %b %Y')}"
    pdf.text "Invoice Number: #{@order.id}"
    pdf.move_down 20

    pdf.text 'Bill To:', size: 12, style: :bold
    pdf.text "#{billing.first_name} #{billing.last_name}"
    pdf.text "#{billing.street} #{billing.bl}"
    pdf.text "#{billing.city}, #{billing.district}, #{billing.country}"
    pdf.move_down 20

    pdf.text 'Products:', size: 12, style: :bold
    pdf.move_down 10

    @order.product_orders.each do |item|
      pdf.text "#{item.product.name}", style: :bold
      pdf.move_down 5
      pdf.text "Quantity: #{item.quantity}"
      pdf.text "Price per unit: $#{item.price}"
      pdf.text "Subtotal: $#{item.quantity*item.price}"
      pdf.move_down 10
    end

    pdf.move_down 20

    pdf.text 'Payment Information:', size: 12, style: :bold
    pdf.text "Subtotal: $#{@order.subtotal}"
    pdf.text "Shipping Tax: $#{@order.shipping_tax}"
    pdf.text "Discount: -$#{@order.discount.value}" if @order.discount.present?
    pdf.text "Total: $#{@order.total}", style: :bold

    tempfile = Tempfile.new(['invoice', '.pdf'], binmode: true)
    pdf.render_file(tempfile.path)
    
    @order.invoice = tempfile
    @order.save
    

    OrderMailer.processed(@order).deliver_now

    session[:cart] = nil
    redirect_to order_path(@order, preview: "allowed"), :flash => {notice: "The order has been processed! You will receive an email in short time with more details"}
  end

  def show
    redirect_to root_path, :flash => {alert: "Forbbiden!"} if current_user.present? && !current_user.client?
    @order = Order.find(params[:id])
    if (current_user.present? && current_user.id != @order.user_id) || (current_user.nil? && params["preview"] != "allowed")
      redirect_back fallback_location: root_path, :flash => {alert: "Forbidden"}
    end
  end

  def sales_report
    redirect_to root_path, :flash => {alert: "Forbbiden"} if current_user.nil? || current_user.client?
    if current_user.staff?
      @brand = Brand.find_by(name: current_user.brand.name)
      products = @brand.product_ids
      product_orders = ProductOrder.where(product_id: products)

      @most_sold_revenue = product_orders.includes(:product)
                            .group("LEFT(products.name, 15)")
                            .sum("product_orders.price * product_orders.quantity")

      @most_feedback = Review.where(product_id: products).includes(:product)
                      .group("LEFT(products.name, 15)")
                      .count("reviews.id")

      @favorites = Favorite.includes(:product)
                  .group("LEFT(products.name, 15)")
                  .count("favorites.id")

      @revenues_country = product_orders.includes(order: :shipping_address).group("shipping_addresses.country").sum("product_orders.price * product_orders.quantity")

    else
      @most_brand = ProductOrder.includes(product: :brand).group("brands.name").sum("product_orders.price * product_orders.quantity")

      result = Order.all.group_by { |order| order.user_id.present? ? "known customers" : "unknown customers" }
      @count_by_customer_type = result.transform_values(&:count)

      @delivery = Order.group(:delivery_method).count

      @revenues_payment = ProductOrder.includes(:order).group("orders.payment_method").sum("product_orders.price * product_orders.quantity")
      @card_types = Order.where(payment_method: "Credit Card").includes(:product_orders, :credit_card).group("credit_cards.card").sum("product_orders.price * product_orders.quantity")
    end

  end

end