class ProductMailer < ActionMailer::Base
  default from: 'adshopping.contact@gmail.com'

  def back_in_stock(product, user)
    @product = Product.find(product)
    @user = User.find(user)

    mail(to: @user.email, subject: '[ADShopping] Back in stock')
  end
end
