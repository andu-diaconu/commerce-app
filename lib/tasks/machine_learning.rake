namespace :machine_learning do
  require 'csv'
  require 'tempfile'
   
  desc "Parse dataset and create db"
  task parse_dataset: :environment do
    puts 'start'

    products = []
    users = []
    users_append = []
    categories = []
    categories_append = []
    product_categories = []
    reviews = []
    product_orders = []
    orders = []
    addresses = []
    credit_cards = []
    filename = 'amazon_dataset.csv'

    CSV.foreach(filename, headers: true) do |row|
      price = row["actual_price"].delete("₹").delete(",").to_f
      eur_price = (price * 0.011).round(2)
      label_name = row["product_name"].split(" ")[0, 6].join(" ")
      about_product = row["about_product"].gsub("|", "\n")
      rating_count = (row["rating_count"].gsub(",","") rescue 0)
      rating_sum = row["rating"].to_f * rating_count.to_i
      products << {identifier: row["product_id"], name: row["product_name"], label_name: label_name, description: about_product, price: eur_price, rating: row["rating"].to_d, rating_count: rating_count.to_i, rating_sum: rating_sum}

      categories_append << row["category"].split("|")
      users_append << row["user_id"].split(",")
    end
    Product.insert_all(products)

    categories_append.flatten.uniq.each do |category|
      categories << {name: category}
    end
    Category.insert_all!(categories)
    
    users_append.flatten.uniq.each do |user_identifier|
      fn = Faker::Name.first_name
      ln = Faker::Name.last_name

      users << {first_name: fn, last_name: ln, email: "#{fn}.#{ln}@gmail.com", role: :Client, identifier: user_identifier}
    end
    User.insert_all(users)

    User.all.each do |usr|
      addresses << {country: ["United States", "United Kingdom", "Romania"] , district: Faker::Address.state, city: Faker::Address.city, street: Faker::Address.street_name, bl: "#{('A'..'Z').to_a.sample}#{rand(10..99).to_s}", apartament: "#{rand(1..99)}", user_id: usr.id}
      credit_cards << {card: ["Visa", "MasterCard", "Revolut"].sample, number: SecureRandom.random_number(10**16).to_s.rjust(16, "0"), 
        month: ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"].sample, year: "#{rand(24..32)}", cvv: "#{rand(101..999)}", 
        owner: usr.full_name, user_id: usr.id}
    end
    ShippingAddress.insert_all(addresses)
    BillingAddress.insert_all(addresses)
    CreditCard.insert_all(credit_cards)

    CSV.foreach(filename, headers: true) do |row|
      product_id = Product.find_by(identifier: row["product_id"]).id
      splitted_categories = row["category"].split("|")
      category = Category.where(name: splitted_categories).pluck(:id)
      category.each do |id|
        product_categories << {product_id: product_id, category_id: id}
      end
      splitted_categories = []
      category = []

      usrs = row["user_id"].split(",")
      rws_titles = row["review_title"].split(",")
      rws_content = row["review_content"].split(",")
      rws_ids = row["review_id"].split(",")
      usrs.each_with_index do |element, index|
        usr = User.find_by(identifier: element)
        if usr.present?
          reviews << {user_id: usr.id, product_id: product_id, title: rws_titles[index], message: rws_content[index], user_identifier: element, identifier: rws_ids[index] }
        end
      end
      usrs = []
      rws_titles = []
      rws_content = []
      rws_ids = []
    end
    Review.insert_all(reviews)
    ProductCategory.insert_all(product_categories)

    brands = []
    35.times do
      name = Faker::Company.name
      pretty_name = name.split(" ").join("-")
      brands << {name: name, website: "http://#{pretty_name}.com", email: "#{pretty_name}@gmail.com"}
    end
    brands <<{name: "Logitech", website: "https://www.logitech.com/", email: "contact@logitech.com"}
    Brand.insert_all(brands)

    products = []
    Product.where("name ILIKE ?", "%logitech%").update_all(brand_id: Brand.find_by(name: "Logitech").id)
    Product.where(brand_id: nil).each do |p|
      p.update(brand_id: rand(1..35))
    end

    User.all.each do |user|
      r = user.reviews.pluck(:product_id).uniq
      subtotal = Product.where(id: r).sum(:price)
      shipping_tax = rand(10..25)
      payment = ["Credit Card", "Credit Card", "Cash"].sample
      deilvery = ["Easy Box", "Courier", "Pick-up from store"]
      orders << {subtotal: subtotal, shipping_tax: shipping_tax, total: (subtotal + shipping_tax), payment_method: payment, delivery_method: deilvery.sample, 
        user_id: user.id, shipping_address_id: user.shipping_address.id, billing_address_id: user.billing_address.id, credit_card_id: user.credit_card.id}
    end
    Order.insert_all(orders)

    Order.all.each do |o|
      product_ids = (o.user.reviews.pluck(:product_id).uniq rescue [])
      products = Product.where(id: product_ids)
      products.each do |p|
        product_orders << {order_id: o.id, product_id: p.id, quantity: 1, price: p.price}
      end
    end
    ProductOrder.insert_all(product_orders)

    puts 'end'
  end

  desc "Parse dataset and save prodcut images in AWS"
  task save_images: :environment do
    puts 'start'

    filename = 'amazon_dataset.csv'
    CSV.foreach(filename, headers: true) do |row|
      if row["img_link"].include?("http")
        url = row['img_link']
        filename = "#{row['product_id']}.jpg"
        
        tempfile = Tempfile.new(['image', '.jpg'])
        open(url, 'rb') do |image|
          tempfile.binmode
          tempfile.write image.read
        end
        
        product = Product.find_by(identifier: row['product_id'])
        product.update!(image: tempfile)
        
        tempfile.close
        tempfile.unlink

      end
    end

    puts 'end'
  end

  desc "Extract batches of users"
  task user_batch: :environment do
    puts 'start'

    batches = []
    filename = 'amazon_dataset.csv'
    CSV.foreach(filename, headers: true) do |row|
      batches << {value: row["user_id"]}
    end
    EncodedUser.insert_all(batches)
    
    puts 'end'
  end
end
