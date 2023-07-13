class UsersController < ApplicationController
  before_action :authenticate_user!
  include Pagy::Backend

  def index
    redirect_to root_path, :flash => {alert: "Forbbiden"} if current_user.nil? || !current_user.admin?
    users = User.where(role: "Staff").includes(:brand).order("brands.name")
    if params[:search].present?
      users = users.where("brands.name ILIKE ? OR users.email ILIKE ? OR users.first_name ILIKE ? OR users.last_name ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end
    @pagy, @users = pagy(users, items: 10)
  end

  def create
    redirect_to root_path, :flash => {alert: "Forbbiden"} if current_user.nil? || !current_user.admin?
    brandid = params["brand_id"].present? ? params["brand_id"].to_i : params["current_brand"].to_i
    @user = User.new(first_name: params["first-name"], last_name: params["last-name"], 
        email: params["email"], brand_id: brandid, 
        role: "Staff", password: params["password"], identifier: ('A'..'Z').to_a.sample(6).join)
    if @user.save
      redirect_back fallback_location: root_path, :flash => {notice: "User added to brand!"}
    else
      redirect_back fallback_location: root_path, :flash => {alert: "Error occured!"}
    end
  end

  def toggle_favorite
    redirect_to root_path, :flash => {alert: "Forbbiden!"} if current_user.staff?
    if current_user.id == params[:id].to_i
      product = Product.find(params[:product_id])
      user = User.find(params[:id])
      if current_user.id == user.id
        fav = Favorite.find_by(user_id: user.id, product_id: product.id)
        if fav.present?
          fav.delete
          redirect_back fallback_location: root_path
        else
          Favorite.create(user_id: user.id, product_id: product.id)
          redirect_back fallback_location: root_path
        end
      end
    else
      redirect_to root_path, :flash => {alert: "Forbidden!"}
    end
  end

  def edit
    if current_user.id != params[:id].to_i && current_user.role != "Admin"
      redirect_back fallback_location: root_path, :flash => {alert: "Forbbiden!"}
    else
      @user = User.find(params[:id])
    end
  end

  def destroy
    redirect_to root_path, :flash => {alert: "Forbbiden!"} if current_user.nil? || !current_user.admin?
    @user = User.find(params[:id])
    @user.messages.destroy_all
    @user.destroy
    redirect_back fallback_location: root_path, :flash => {notice: "User removed from system!"}
  end

  def update
    if current_user.id != params[:id].to_i && current_user.role != "Admin"
      redirect_back fallback_location: root_path, :flash => {alert: "Forbbiden!"}
    else
      @user = User.find(params[:id])

      if params["country-billing"].present? &&  params["district-billing"].present? &&  params["city-billing"].present? &&  params["street-billing"].present? &&  params["bl-billing"].present? && params["first-name-billing"].present?
        params["last-name-billing"].present? &&  params["email-billing"].present? &&  params["phone-billing"].present?
        BillingAddress.where(user_id: @user.id).update(user_id: nil)
        BillingAddress.find_or_create_by(
          country: params["country-biling"],
          district: params["district-billing"],
          city: params["city-billing"],
          street: params["street-billing"],
          bl: params["bl-billing"],
          first_name: params["first-name-billing"],
          last_name: params["last-name-billing"],
          email: params["email-billing"],
          phone: params["phone-billing"],
          user_id: @user.id
        )
      end

      if params["country-shipping"].present? &&  params["district-shipping"].present? &&  params["city-shipping"].present? &&  params["street-shipping"].present? &&  params["bl-shipping"].present? && params["first-name-shipping"].present?
        params["last-name-shipping"].present? &&  params["email-shipping"].present? &&  params["phone-shipping"].present?
        ShippingAddress.where(user_id: @user.id).update(user_id: nil)
        ShippingAddress.find_or_create_by(
          country: params["country-shipping"],
          district: params["district-shipping"],
          city: params["city-shipping"],
          street: params["street-shipping"],
          bl: params["bl-shipping"],
          first_name: params["first-name-shipping"],
          last_name: params["last-name-shipping"],
          email: params["email-shipping"],
          phone: params["phone-shipping"],
          user_id: @user.id
        )
      end

      if params["card-type"].present? && params["card-number"].present? && params["expiration-month"].present? && params["expiration-year"].present? && params["cvv"].present? && params["cardholder-name"].present?
        CreditCard.where(user_id: @user.id).update(user_id: nil)
        CreditCard.find_or_create_by(
          card: params["card-type"],
          number: params["card-number"],
          month: params["expiration-month"],
          year: params["expiration-year"],
          cvv: params["cvv"],
          owner: params["cardholder-name"],
          user_id: @user.id
        )
      end

      @user.update(
        first_name: params["first-name"],
        last_name: params["last-name"],
        email: params["email"],
      )
      @user.update(image: params["upload-image"]) if params["upload-image"].present?

      redirect_back fallback_location: root_path, :flash => {notice: "Details successfully updated!"}

    end
  end

  def let_me_know
    if current_user.present? && current_user.client?
      if Customer.find_by(product_id: params[:product_id], user_id: current_user.id, done: false).present?
        redirect_back fallback_location: root_path, :flash => {alert: "You are already in our queue! When we have this item, we let you know"}
      else
        Customer.create(product_id: params[:product_id], user_id: current_user.id)
        redirect_back fallback_location: root_path, :flash => {notice: "You will receive an e-mail when this product is back in stock! Thank you"}
      end
    else
      redirect_to root_path, :flash => {alert: "Forbbiden"}
    end
  end

end