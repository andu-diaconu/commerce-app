ApplicationRecord.transaction do 

  puts "Destroying tables..."
  User.destroy_all
  Order.destroy_all
  Message.destroy_all
  CreditCard.destroy_all
  ShippingAddress.destroy_all
  BillingAddress.destroy_all
  Discount.destroy_all
  ProductOrder.destroy_all
  Favorite.destroy_all
  Feedback.destroy_all
  Cart.destroy_all
  ProductCart.destroy_all
  Product.destroy_all
  Brand.destroy_all
  Electronic.destroy_all
  Entertainment.destroy_all
  Fashion.destroy_all
  Sensor.destroy_all
  Function.destroy_all
  Package.destroy_all
  ElectronicFunction.destroy_all
  ElectronicSensor.destroy_all
  EntertainmentFunction.destroy_all
  EntertainmentPackage.destroy_all

  puts "Resetting primary keys..."
  ApplicationRecord.connection.reset_pk_sequence!('users')
  ApplicationRecord.connection.reset_pk_sequence!('orders')
  ApplicationRecord.connection.reset_pk_sequence!('messages')
  ApplicationRecord.connection.reset_pk_sequence!('product_orders')
  ApplicationRecord.connection.reset_pk_sequence!('credit_cards')
  ApplicationRecord.connection.reset_pk_sequence!('shipping_addresses')
  ApplicationRecord.connection.reset_pk_sequence!('billing_addresses')
  ApplicationRecord.connection.reset_pk_sequence!('discounts')
  ApplicationRecord.connection.reset_pk_sequence!('favorites')
  ApplicationRecord.connection.reset_pk_sequence!('feedbacks')
  ApplicationRecord.connection.reset_pk_sequence!('carts')
  ApplicationRecord.connection.reset_pk_sequence!('product_carts')
  ApplicationRecord.connection.reset_pk_sequence!('products')
  ApplicationRecord.connection.reset_pk_sequence!('brands')
  ApplicationRecord.connection.reset_pk_sequence!('electronics')
  ApplicationRecord.connection.reset_pk_sequence!('entertainments')
  ApplicationRecord.connection.reset_pk_sequence!('fashions')
  ApplicationRecord.connection.reset_pk_sequence!('sensors')
  ApplicationRecord.connection.reset_pk_sequence!('functions')
  ApplicationRecord.connection.reset_pk_sequence!('packages')
  ApplicationRecord.connection.reset_pk_sequence!('electronic_functions')
  ApplicationRecord.connection.reset_pk_sequence!('electronic_sensors')
  ApplicationRecord.connection.reset_pk_sequence!('entertainment_functions')
  ApplicationRecord.connection.reset_pk_sequence!('entertainment_packages')


  # Brands
  brands = ["Apple", "Samsung", "Google", "Lenovo", "Asus", "Dell", "PlayStation", "Xbox", "Nintendo", "Zara", "Collins", "Nike", "Vans", "Polo" ]
  brands_bulk = []

  brands.each do |brand|
    brands_bulk << {name: brand, website: "https://www.#{brand.downcase}.com/", email: "#{brand.downcase}@contact.com"}
  end
  Brand.insert_all(brands_bulk)

  # Clients
  clients_bulk = []
  20.times do
    fn = Faker::Name.first_name
    ln = Faker::Name.last_name
    clients_bulk << {first_name: fn, last_name: ln, email: "#{fn}.#{ln}@gmail.com", role: :Client}
  end
  User.insert_all(clients_bulk)

  # Staff
  staff_bulk = []

  # Discount
  discounts_bulk = []

  Brand.all.each do |brand|
    staff_first_name = Faker::Name.first_name
    staff_bulk << {first_name: staff_first_name, last_name: Faker::Name.last_name, email: "#{staff_first_name}.staff@#{brand.name.downcase}.com", role: :Staff, brand_id: brand.id}
    discounts_bulk << {code: "#{brand.name.upcase}10", value: 10, brand_id: brand.id}
  end
  User.insert_all(staff_bulk)
  Discount.insert_all(discounts_bulk)
  
  # Admin
  User.create(
    first_name: "Admin",
    last_name: "Diaconu",
    email: "admin@ads.com",
    role: :Admin,
    password: "123456"
  )

  #Addresses
  cities = ["Cluj-Napoca", "Timisoara", "Iasi", "Oradea", "Petrosani", "Sibiu", "Brasov", "Arad", "Tg. Mures", "Bucuresti"]
  districts = {
    "Cluj-Napoca": "Cluj",
    "Timisoara": "Timis",
    "Iasi": "Iasi",
    "Oradea": "Bihor",
    "Petrosani": "Hunedoara",
    "Sibiu": "Sibiu",
    "Brasov": "Brasov",
    "Arad": "Arad",
    "Tg. Mures": "Mures",
    "Bucuresti": "Bucuresti"
  }
  streets = ["Tudor Vladimirescu", "Republicii", "Septimiu Albimiu Nord", "Augustin Buzura", "Gheorghe Dima", "Plevnei", "Lucian Blaga", "Augstin Presecan"]
  addresses_bulk = []

  # CreditCards
  cards = ["Visa", "MasterCard", "Revolut"]
  months = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
  cards_bulk = []

  User.where(role: :Client).each do |client|
    city = cities.sample
    addresses_bulk << {country: "Romania", district: districts["#{city}"], city: city, street: "#{streets.sample} #{rand(1..20)}", bl: rand(1..10), apartament: rand(1..100), user_id: client.id}

    card = cards.sample
    random_string = SecureRandom.random_number(10**16).to_s.rjust(16, "0")
    cards_bulk << {card: card, number: random_string, month: months.sample, year: "#{rand(24..32)}", cvv: "#{rand(101..999)}", owner: "#{client.first_name} #{client.last_name}", user_id: client.id}
  end
  ShippingAddress.insert_all(addresses_bulk)
  BillingAddress.insert_all(addresses_bulk)
  CreditCard.insert_all(cards_bulk)


  ############ ELECTRONICS ############

  Product.create(
    name: "Apple iPhone 12 Pro",
    description: "5G smartphone with A14 Bionic chip and triple-camera system",
    price: 1300,
    stock: 5,
    colour: "Graphite",
    brand_id: 1
  )
  
  Electronic.create(
    processor: "A14 Bionic",
    processor_frequency: "2.99",
    video_card: "Apple-designed GPU",
    screen_size: 6.1,
    os: "iOS 14",
    battery: "Built-in rechargeable lithium-ion",
    weight: 189,
    memory_type: "RAM",
    memory: 6,
    refresh_rate: 60,
    production_year: "2020",
    product_id: 1,
    category: 4
  )

  
  Product.create(
    name: "Apple Watch Series 6",
    description: "Smartwatch with always-on Retina display and blood oxygen sensor",
    price: 800,
    stock: 3,
    colour: "Silver",
    brand_id: 1
  )
  
  Electronic.create(
    processor: "S6 SiP with 64-bit dual-core processor",
    processor_frequency: "N/A",
    video_card: "Apple GPU",
    screen_size: 1.78,
    os: "watchOS 7",
    battery: "Built-in rechargeable lithium-ion",
    weight: 47.1,
    memory_type: "RAM",
    memory: 1,
    refresh_rate: 60,
    production_year: "2020",
    product_id: 2,
    category: 0
  )

  Product.create(
    name: "Samsung Galaxy S21 Ultra",
    description: "5G smartphone with 108MP camera and S Pen support",
    price: 1199,
    stock: 4,
    colour: "Phantom Black",
    brand_id: 2
  )
  
  Electronic.create(
    processor: "Exynos 2100",
    processor_frequency: "2.9",
    video_card: "Mali-G78 MP14",
    screen_size: 6.8,
    os: "Android 11",
    battery: "Li-Ion 5000 mAh",
    weight: 227,
    memory_type: "RAM",
    memory: 12,
    refresh_rate: 120,
    production_year: "2021",
    product_id: 3,
    category: 3
  )

  Product.create(
    name: "Dell XPS 13",
    description: "Ultrabook with 11th Gen Intel Core processors and InfinityEdge display",
    price: 1299,
    stock: 2,
    colour: "Platinum Silver",
    brand_id: 7
  )
  
  Electronic.create(
    processor: "11th Gen Intel Core i7-1185G7",
    processor_frequency: "4.8",
    video_card: "Intel Iris Xe Graphics",
    screen_size: 13.4,
    os: "Windows 10 Home",
    battery: "52 Whr battery",
    weight: 1.2,
    memory_type: "SSD",
    memory: 512,
    refresh_rate: 60,
    production_year: "2021",
    product_id: 4,
    category: :Laptop
  )

  Product.create(
    name: "Apple MacBook Air M1",
    description: "13-inch laptop with Apple M1 chip and Retina display",
    price: 999,
    stock: 3,
    colour: "Gold",
    brand_id: 1
  )
  
  Electronic.create(
    processor: "Apple M1 chip",
    processor_frequency: "3.2",
    video_card: "Apple-designed 8-core GPU",
    screen_size: 13.3,
    os: "macOS Big Sur",
    battery: "49.9‑watt‑hour",
    weight: 2.8,
    memory_type: "SSD",
    memory: 256,
    refresh_rate: 60,
    production_year: "2020",
    product_id: 5,
    category: :Laptop
  )

  Product.create(
    name: "Google Pixel 5",
    description: "5G smartphone with dual rear cameras and Night Sight mode",
    price: 699,
    stock: 4,
    colour: "Sorta Sage",
    brand_id: 3
  )
  
  Electronic.create(
    processor: "Qualcomm Snapdragon 765G",
    processor_frequency: "2.4",
    video_card: "Adreno 620",
    screen_size: 6.0,
    os: "Android 11",
    battery: "4080 mAh",
    weight: 151,
    memory_type: "RAM",
    memory: 8,
    refresh_rate: 90,
    production_year: "2020",
    product_id: 6,
    category: 2
  )

  Product.create(
    name: "ASUS ROG Zephyrus G14",
    description: "14-inch gaming laptop with AMD Ryzen 9 processor and NVIDIA GeForce RTX 2060 graphics",
    price: 1499,
    stock: 2,
    colour: "Eclipse Gray",
    brand_id: 5
  )
  
  Electronic.create(
    processor: "AMD Ryzen 9 4900HS",
    processor_frequency: "4.3",
    video_card: "NVIDIA GeForce RTX 2060",
    screen_size: 14.0,
    os: "Windows 10 Home",
    battery: "76 WHrs, 4S1P, 4-cell Li-ion",
    weight: 1.6,
    memory_type: "SSD",
    memory: 1,
    refresh_rate: 120,
    production_year: "2020",
    product_id: 7,
    category: :Laptop
  )

  Product.create(
    name: "Samsung Galaxy Watch 3",
    description: "Smartwatch with rotating bezel and heart rate monitor",
    price: 399,
    stock: 3,
    colour: "Mystic Black",
    brand_id: 2
  )
  
  Electronic.create(
    processor: "Exynos 9110",
    processor_frequency: "1.15",
    video_card: "Mali-T720",
    screen_size: 1.4,
    os: "Tizen-based wearable OS 5.5",
    battery: "340mAh",
    weight: 48.2,
    memory_type: "RAM",
    memory: 1,
    refresh_rate: 60,
    production_year: "2020",
    product_id: 8,
    category: 1
  )

  Product.create(
    name: "Samsung Galaxy Tab S7 Plus",
    description: "Android tablet with 12.4-inch AMOLED display and S-Pen support",
    price: 849,
    stock: 4,
    colour: "Mystic Black",
    brand_id: 2
  )
  
  Electronic.create(
    processor: "Qualcomm Snapdragon 865 Plus",
    processor_frequency: "3.09",
    video_card: "Adreno 650",
    screen_size: 12.4,
    os: "Android 11",
    battery: "10090mAh",
    weight: 575,
    memory_type: "LPDDR5",
    memory: 6,
    refresh_rate: 120,
    production_year: "2020",
    product_id: 9,
    category: 3
  )

  
  Product.create(
    name: "Google Gram 16",
    description: "16-inch lightweight laptop with long battery life and Thunderbolt 4",
    price: 1399,
    stock: 6,
    colour: "Dark Silver",
    brand_id: 3
  )
  
  Electronic.create(
    processor: "Intel Core i7-1165G7",
    processor_frequency: "4.7",
    video_card: "Intel Iris Xe Graphics",
    screen_size: 16,
    os: "Windows 10 Home",
    battery: "80Wh",
    weight: 1190,
    memory_type: "DDR4",
    memory: 16,
    refresh_rate: 60,
    production_year: "2021",
    product_id: 10,
    category: 3
  )
  
  Product.create(
    name: "Apple Watch Series 8",
    description: "New smartwatch from Apple with always-on display and improved health features",
    price: 399,
    stock: 8,
    colour: "Space Gray",
    brand_id: 1
  )
  
  Electronic.create(
    processor: "S8 SiP with 64-bit dual-core processor",
    processor_frequency: "N/A",
    video_card: "N/A",
    screen_size: 1.5,
    os: "watchOS 9",
    battery: "18 hours",
    weight: 47,
    memory_type: "N/A",
    memory: "32GB",
    refresh_rate: "60Hz",
    production_year: "2023",
    product_id: 11,
    category: 0
  )

  Product.create(
    name: "Google Pixel 6",
    description: "Android smartphone with Google Tensor chip and 6.4-inch OLED display",
    price: 699,
    stock: 7,
    colour: "Stormy Black",
    brand_id: 3
  )
  
  Electronic.create(
    processor: "Google Tensor",
    processor_frequency: "N/A",
    video_card: "N/A",
    screen_size: 6.4,
    os: "Android 12",
    battery: "4614mAh",
    weight: 210,
    memory_type: "LPDDR5",
    memory: 8,
    refresh_rate: 90,
    production_year: "2022",
    product_id: 12,
    category: 3
  )



  ################ ENTERTAINMENT ##################

  Product.create(
    name: "PlayStation 5",
    description: "PlayStation 5 with 2 games included",
    price: 1300,
    stock: 10,
    colour: "White",
    brand_id: 7
  )

  Entertainment.create(
    memory: "16 GB GDDR6 - 825 GB SSD",
    edition: "x86-64-AMD Ryzen Zen 2",
    controllers: 1,
    weight: 4.5,
    production_year: "2022",
    category: 0,
    product_id: 13
  )

  Product.create(
    name: "Nintendo Switch Lite",
    description: "Handheld console with 3 games included",
    price: 250,
    stock: 5,
    colour: "Yellow",
    brand_id: 9
  )

  Entertainment.create(
    memory: "32GB",
    edition: "Nvidia Tegra X1",
    controllers: 0,
    weight: 0.61,
    production_year: "2021",
    category: 2,
    product_id: 14
  )


  Product.create(
    name: "PlayStation 4 Pro",
    description: "PS4 Pro with 2 games included",
    price: 400,
    stock: 8,
    colour: "Black",
    brand_id: 7
  )

  Entertainment.create(
    memory: "1TB",
    edition: "AMD Jaguar",
    controllers: 1,
    weight: 3.3,
    production_year: "2016",
    category: 0,
    product_id: 15
  )

  Product.create(
    name: "Xbox Series X",
    description: "Xbox Series X with 3 games included",
    price: 700,
    stock: 4,
    colour: "Black",
    brand_id: 8
  )

  Entertainment.create(
    memory: "16 GB GDDR6 - 1TB SSD",
    edition: "AMD Zen 2",
    controllers: 1,
    weight: 4.45,
    production_year: "2020",
    category: 1,
    product_id: 16
  )

  Product.create(
    name: "Nintendo 3DS XL",
    description: "Handheld console with 3 games included",
    price: 200,
    stock: 6,
    colour: "Red",
    brand_id: 9
  )
  
  Entertainment.create(
    memory: "20GB",
    edition: "Dual-core ARM11 MPCore",
    controllers: 0,
    weight: 0.336,
    production_year: "2012",
    category: 2,
    product_id: 17
  )

  Product.create(
    name: "Xbox One S",
    description: "Xbox One S with 2 games included",
    price: 350,
    stock: 9,
    colour: "White",
    brand_id: 8
  )
  Entertainment.create(
    memory: "1TB",
    edition: "AMD Jaguar",
    controllers: 1,
    weight: 2.9,
    production_year: "2016",
    category: 1,
    product_id: 18
  )
    
  Product.create(
    name: "PlayStation 3",
    description: "PS3 with 2 games included",
    price: 250,
    stock: 7,
    colour: "Black",
    brand_id: 7
  )

  Entertainment.create(
    memory: "320GB",
    edition: "IBM Cell",
    controllers: 1,
    weight: 5,
    production_year: "2006",
    category: 0,
    product_id: 19
  )

  Product.create(
    name: "Nintendo Switch",
    description: "Nintendo Switch with 3 games included",
    price: 400,
    stock: 15,
    colour: "Neon Red/Blue",
    brand_id: 9
  )
  
  Entertainment.create(
    memory: "32 GB eMMC",
    edition: "Custom NVIDIA Tegra processor",
    controllers: 2,
    weight: 0.88,
    production_year: "2019",
    category: 2,
    product_id: 14
  )

  Product.create(
    name: "Nintendo Switch",
    description: "Nintendo Switch with 3 games included",
    price: 400,
    stock: 15,
    colour: "Neon Red/Blue",
    brand_id: 6
  )
  
  Entertainment.create(
    memory: "32 GB eMMC",
    edition: "Custom NVIDIA Tegra processor",
    controllers: 2,
    weight: 0.88,
    production_year: "2019",
    category: 2,
    product_id: 14
  )
  
  Product.create(
    name: "PlayStation 4 Pro",
    description: "PlayStation 4 Pro with 2 games included",
    price: 450,
    stock: 12,
    colour: "Jet Black",
    brand_id: 7
  )
  
  Entertainment.create(
    memory: "8 GB GDDR5",
    edition: "Custom AMD Jaguar processor",
    controllers: 1,
    weight: 3.3,
    production_year: "2016",
    category: 0,
    product_id: 16
  )



  ##################### FASHION ####################

  Product.create(
    name: "Zara T-shirt Black Squad",
    description: "Black Squad Collection brand new T-Shirt",
    price: 20,
    colour: "Black",
    brand_id: 10
  )

  Fashion.create(
    size: "S,M,L",
    sex: "M",
    season: "Summer",
    model: "Basic",
    material: "Cotton",
    style: "Modern",
    category: 0,
    product_id: 17
  )
  
  Product.create(
    name: "Zara Denim Jacket",
    description: "Classic denim jacket with pockets",
    price: 60,
    colour: "Blue",
    brand_id: 10
  )
  
  Fashion.create(
    size: "S,M,L",
    sex: "M",
    season: "Fall",
    model: "Classic",
    material: "Denim",
    style: "Casual",
    category: 4,
    product_id: 18
  )
  
  Product.create(
    name: "Zara White Sneakers",
    description: "White sneakers with gold details",
    price: 50,
    colour: "White",
    brand_id: 10
  )
  
  Fashion.create(
    size: "41,42,43",
    sex: "M",
    season: "Summer",
    model: "Sneakers",
    material: "Leather",
    style: "Streetwear",
    category: 3,
    product_id: 19
  )
  
  Product.create(
    name: "Zara High Waisted Jeans",
    description: "High waisted skinny jeans with ripped knees",
    price: 40,
    colour: "Blue",
    brand_id: 10
  )
  
  Fashion.create(
    size: "XS,S",
    sex: "F",
    season: "Spring",
    model: "Skinny",
    material: "Denim",
    style: "Casual",
    category: 2,
    product_id: 20
  )
  
  Product.create(
    name: "Zara Printed Midi Dress",
    description: "Midi dress with floral print",
    price: 35,
    colour: "Multicolour",
    brand_id: 10
  )
  
  Fashion.create(
    size: "XS,S,M,L",
    sex: "F",
    season: "Summer",
    model: "Midi",
    material: "Polyester",
    style: "Boho",
    category: 1,
    product_id: 21
  )
  
  Product.create(
    name: "Zara Oversized Hoodie",
    description: "Oversized hoodie with drawstring",
    price: 45,
    colour: "Grey",
    brand_id: 10
  )
  
  Fashion.create(
    size: "XS,S,M,L",
    sex: "M",
    season: "Fall",
    model: "Hoodie",
    material: "Cotton",
    style: "Casual",
    category: 4,
    product_id: 22
  )
  
  
  
  # Order.create(
  #   subtotal: 400,
  #   shipping_tax: 15,
  #   discount_id: 1,
  #   total: 375,
  #   payment_method: "Credit Card",
  #   delivery_method: "Easybox",
  #   user_id: 2,
  #   shipping_address_id: 1,
  #   billing_address_id: 1,
  #   credit_card_id: 1,
  # )

  # ProductOrder.create(
  #   order_id: 1,
  #   product_id: 1,
  #   quantity: 1,
  #   price: 200
  # )

  # ProductOrder.create(
  #   order_id: 1,
  #   product_id: 2,
  #   quantity: 1,
  #   price: 200
  # )

  # Sensor.create(
  #   name: "Amprent",
  #   description: "Unlock your device using amprent"
  # )

  # Sensor.create(
  #   name: "Temperature",
  #   description: "Turn on the coolor when temperature is over limit"
  # )

  # ElectronicSensor.create(
  #   sensor_id: 1,
  #   electronic_id: 2
  # )

  # ElectronicSensor.create(
  #   sensor_id: 2,
  #   electronic_id: 1
  # )

  # Favorite.create(
  #   user_id: 2,
  #   product_id: 1
  # )

  # Feedback.create(
  #   user_id: 2,
  #   product_id: 1,
  #   message: "Smooth"
  # )

end