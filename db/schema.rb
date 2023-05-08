# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_30_215818) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billing_addresses", force: :cascade do |t|
    t.string "country"
    t.string "district"
    t.string "city"
    t.string "street"
    t.string "bl"
    t.string "apartament"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "brands", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "website"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", force: :cascade do |t|
    t.string "status"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string "card"
    t.string "number"
    t.string "month"
    t.string "year"
    t.string "cvv"
    t.string "owner"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discounts", force: :cascade do |t|
    t.string "code"
    t.decimal "value"
    t.integer "brand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "electronic_functions", force: :cascade do |t|
    t.integer "electronic_id"
    t.integer "function_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "electronic_sensors", force: :cascade do |t|
    t.integer "electronic_id"
    t.integer "sensor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "electronics", force: :cascade do |t|
    t.string "processor"
    t.float "processor_frequency"
    t.string "video_card"
    t.float "screen_size"
    t.string "os"
    t.string "battery"
    t.float "weight"
    t.string "memory_type"
    t.integer "memory"
    t.float "refresh_rate"
    t.string "web_camera"
    t.string "audio"
    t.integer "category"
    t.string "production_year"
    t.integer "product_id"
    t.bigint "electronic_function_id"
    t.bigint "electronic_sensor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["electronic_function_id"], name: "index_electronics_on_electronic_function_id"
    t.index ["electronic_sensor_id"], name: "index_electronics_on_electronic_sensor_id"
  end

  create_table "entertainment_functions", force: :cascade do |t|
    t.integer "entertainment_id"
    t.integer "function_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entertainment_packages", force: :cascade do |t|
    t.integer "entertainment_id"
    t.integer "package_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entertainments", force: :cascade do |t|
    t.string "memory"
    t.string "edition"
    t.integer "controllers"
    t.float "weight"
    t.string "production_year"
    t.integer "category"
    t.integer "product_id"
    t.bigint "entertainment_function_id"
    t.bigint "entertainment_package_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entertainment_function_id"], name: "index_entertainments_on_entertainment_function_id"
    t.index ["entertainment_package_id"], name: "index_entertainments_on_entertainment_package_id"
  end

  create_table "fashions", force: :cascade do |t|
    t.string "size"
    t.string "sex"
    t.string "season"
    t.string "model"
    t.string "material"
    t.string "close_system"
    t.string "style"
    t.integer "category"
    t.integer "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "product_id"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "functions", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "subtotal"
    t.decimal "shipping_tax"
    t.integer "discount_id"
    t.decimal "total"
    t.string "payment_method"
    t.string "delivery_method"
    t.integer "user_id"
    t.integer "shipping_address_id"
    t.integer "billing_address_id"
    t.integer "credit_card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "packages", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_carts", force: :cascade do |t|
    t.integer "cart_id"
    t.integer "product_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_orders", force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.integer "quantity"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description"
    t.decimal "price", default: "10.0", null: false
    t.integer "stock", default: 10, null: false
    t.string "colour"
    t.integer "brand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sensors", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_addresses", force: :cascade do |t|
    t.string "country"
    t.string "district"
    t.string "city"
    t.string "street"
    t.string "bl"
    t.string "apartament"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 0
    t.integer "shipping_address_id"
    t.integer "billing_address_id"
    t.integer "credit_card_id"
    t.integer "brand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "billing_addresses", "users"
  add_foreign_key "carts", "users"
  add_foreign_key "credit_cards", "users"
  add_foreign_key "discounts", "brands"
  add_foreign_key "electronics", "electronic_functions"
  add_foreign_key "electronics", "electronic_sensors"
  add_foreign_key "electronics", "products"
  add_foreign_key "entertainments", "entertainment_functions"
  add_foreign_key "entertainments", "entertainment_packages"
  add_foreign_key "entertainments", "products"
  add_foreign_key "fashions", "products"
  add_foreign_key "favorites", "products"
  add_foreign_key "favorites", "users"
  add_foreign_key "feedbacks", "products"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "orders", "billing_addresses"
  add_foreign_key "orders", "credit_cards"
  add_foreign_key "orders", "shipping_addresses"
  add_foreign_key "orders", "users"
  add_foreign_key "product_carts", "carts"
  add_foreign_key "product_carts", "products"
  add_foreign_key "product_orders", "orders"
  add_foreign_key "product_orders", "products"
  add_foreign_key "products", "brands"
  add_foreign_key "shipping_addresses", "users"
  add_foreign_key "users", "brands"
end
