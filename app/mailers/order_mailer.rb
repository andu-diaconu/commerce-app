class OrderMailer < ActionMailer::Base
  default from: 'adshopping.contact@gmail.com'

  def processed(order)
    @order = order
    @shipping = @order.shipping_address

    mail(to: order.shipping_address.email, subject: '[ADShopping] Successfull order')
  end
end
