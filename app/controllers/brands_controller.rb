class BrandsController < ApplicationController
  include Pagy::Backend

  def index
    if current_user.nil? || !current_user.staff?
      brands = Brand.where(hidden: false).order(name: :asc)
      if params[:search].present?
        brands = brands.where("name ILIKE ?", "%#{params[:search]}%")
      end
      @pagy, @brands = pagy(brands, items: 10)
    else
      redirect_to root_path, :flash => {alert: "Forbbiden!"}
    end
  end

  def new
    @brand = Brand.new
  end
  
  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      Room.create!(name: @brand.name)
      redirect_to brands_path, :flash => { notice: "Brand added successfully!"}
    else
      respond_to do |format|
        format.html{
          flash.now[:alert] = @brand.errors.full_messages.join("<br/>".html_safe)
          render :new
        }
      end  
    end
  end
  
  def edit
    @brand = Brand.find(params[:id])
    render :new
  end
  
  def update
    @brand = Brand.find(params[:id])
    room = Room.find_by(name: @brand.name)
    if @brand.update(brand_params)
      room.update(name: @brand.name)
      redirect_to brands_path, :flash => { notice: "Brand updated successfully!"}
    else
      respond_to do |format|
        format.html{
          flash.now[:alert] = @brand.errors.full_messages.join("<br/>".html_safe)
          render :new
        }
      end
    end
  end
  
  def destroy
    @brand = Brand.find(params[:id])
    User.where(brand_id: @brand.id).each do |u|
      u.messages.delete_all
    end
    User.where(brand_id: @brand.id).delete_all
    Room.find_by(name: @brand.name).messages.delete_all
    Room.find_by(name: @brand.name).delete
    
    Product.where(brand_id: @brand.id).update_all(hidden: true)
    
    @brand.update(hidden: true)
    redirect_to brands_path, :flash => {notice: "Brand removed successfully!"}
  end

  def create_staff
    redirect_to root_path, :flash => {alert: "Forbbiden"} if current_user.nil? || !current_user.admin?
    brandid = params["brand_id"].present? ? params["brand_id"].to_i : params["current_brand"].to_i
    @user = User.create!(first_name: params["first-name"], last_name: params["last-name"], 
        email: params["email"], brand_id: brandid, role: "Staff",
        password: params["password"], identifier: ('A'..'Z').to_a.sample(6).join)
    redirect_back fallback_location: root_path, :flash => {notice: "User added to brand!"}
  end
  
  private
    def brand_params
      params.require(:brand).permit(:id, :name, :color, :website, :country, :logo, :email, :phone, :abbreviation)
    end

end