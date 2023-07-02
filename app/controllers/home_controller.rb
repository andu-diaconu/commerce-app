class HomeController < ApplicationController
  def index
    # Guard 
    redirect_to products_path if current_user.present? && current_user.staff?
    redirect_to brands_path if current_user.present? && current_user.admin?

    # Extract random good products for new customers
    product_ids = Product.where.not(image: nil).order(rating_sum: :desc).first(15)
    products = Product.where(id: product_ids.sample(3))

    @products = products
  end
end
