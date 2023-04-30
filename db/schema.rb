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

ActiveRecord::Schema[7.0].define(version: 2023_04_30_211147) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  add_foreign_key "electronics", "electronic_functions"
  add_foreign_key "electronics", "electronic_sensors"
  add_foreign_key "entertainments", "entertainment_functions"
  add_foreign_key "entertainments", "entertainment_packages"
end
