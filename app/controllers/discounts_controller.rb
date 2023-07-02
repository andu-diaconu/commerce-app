class DiscountsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_staff

  def index
    set_brand
    @discounts = @brand.discounts
  end

  def edit
    set_brand
    @discount = Discount.find(params[:id])
    redirect_to root_path, :flash => {alert: "Forbbiden"} if @discount.brand_id != @brand.id
    render :new
  end

  def new
    @discount = Discount.new
  end

  def create
    set_brand
    @discount = Discount.new(discount_params)
    @discount.brand_id = @brand.id
    if @discount.save
      redirect_to discounts_path, :flash => { notice: "Coupon has been created successfully!"}
    else
      respond_to do |format|
        format.html{
          flash.now[:alert] = @disocunt.errors.full_messages.join("<br/>".html_safe)
          render :new
        }
      end  
    end
  end

  def update
    set_brand
    @discount = Discount.find(params[:id])
    redirect_to root_path, :flash => {alert: "Forbbiden"} if @discount.brand_id != @brand.id

    if @discount.update(discount_params)  
      redirect_to discounts_path, :flash => { notice: "Coupon updated successfully!"}
    else
      respond_to do |format|
        format.html{
          flash.now[:alert] = @discount.errors.full_messages.join("<br/>".html_safe)
          render :new
        }
      end
    end
  end

  def destroy
    set_brand
    @discount = Discount.find(params[:id])
    redirect_to root_path, :flash => {alert: "Forbbiden"} if @discount.brand_id != @brand.id
    @discount.destroy
    redirect_to discounts_path, :flash => { notice: "Coupon has been successfully removed!"}
  end

  private

  def check_staff
    if current_user.nil? || current_user.role != "Staff"
      redirect_to :root_path, :flash => {alert: "Forbbiden!"}
    end
  end

  def set_brand
    @brand = Brand.find_by(name: current_user.brand.name)
  end

  def discount_params
    params.require(:discount).permit(:value, :code, :expires_at)
  end

end