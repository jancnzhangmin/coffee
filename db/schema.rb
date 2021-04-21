# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_30_063144) do

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "login"
    t.string "password_digest"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "agentareas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "province"
    t.string "city"
    t.string "district"
    t.string "adcode"
    t.integer "member"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "agentareausers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "agentarea_id"
    t.datetime "begintime"
    t.datetime "endtime"
    t.float "amount"
    t.integer "paystatus"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["agentarea_id"], name: "index_agentareausers_on_agentarea_id"
  end

  create_table "agentlevels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.float "profitratio"
    t.bigint "corder"
    t.integer "frontdisplay"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "rebate"
    t.integer "isyearend"
    t.string "businetype"
  end

  create_table "areaamounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.float "province"
    t.float "city"
    t.float "district"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "banners", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "banner"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "corder"
  end

  create_table "banners_products", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "banner_id", null: false
    t.bigint "product_id", null: false
  end

  create_table "buycars", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "user_id"
    t.float "number"
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_buycars_on_product_id"
    t.index ["user_id"], name: "index_buycars_on_user_id"
  end

  create_table "contractdetails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "contract_id"
    t.string "contractimg"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contract_id"], name: "index_contractdetails_on_contract_id"
  end

  create_table "contracts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "shop_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.integer "status"
    t.index ["shop_id"], name: "index_contracts_on_shop_id"
    t.index ["user_id"], name: "index_contracts_on_user_id"
  end

  create_table "evaluateimgs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "evaluate_id"
    t.string "evaluateimg"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["evaluate_id"], name: "index_evaluateimgs_on_evaluate_id"
  end

  create_table "evaluates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "user_id"
    t.float "speed"
    t.float "quality"
    t.text "summary"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_evaluates_on_product_id"
    t.index ["user_id"], name: "index_evaluates_on_user_id"
  end

  create_table "examines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "agentlevel_id"
    t.bigint "user_id"
    t.datetime "examinedate"
    t.integer "checkexamine"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["agentlevel_id"], name: "index_examines_on_agentlevel_id"
    t.index ["user_id"], name: "index_examines_on_user_id"
  end

  create_table "expresscodes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "comcode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "imgresources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "img"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "incomes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.float "amount"
    t.string "ordernumber"
    t.integer "status"
    t.string "summary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "profittype"
    t.index ["user_id"], name: "index_incomes_on_user_id"
  end

  create_table "orderdelivers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "order_id"
    t.string "com"
    t.string "nu"
    t.text "cdata"
    t.string "company"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_orderdelivers_on_order_id"
  end

  create_table "orderdetails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "order_id"
    t.float "number"
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_orderdetails_on_order_id"
    t.index ["product_id"], name: "index_orderdetails_on_product_id"
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.string "ordernumber"
    t.string "contact"
    t.string "contactphone"
    t.string "province"
    t.string "city"
    t.string "district"
    t.string "adcode"
    t.string "address"
    t.integer "paystatus"
    t.integer "receivestatus"
    t.integer "evaluatestatus"
    t.string "summary"
    t.integer "afterstatus"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "deliverstatus"
    t.datetime "paytime"
    t.datetime "receivetime"
    t.datetime "evaluatetime"
    t.float "amount"
    t.float "profit"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "posters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.string "poster"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_posters_on_product_id"
  end

  create_table "productbanners", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.string "banner"
    t.bigint "corder"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_productbanners_on_product_id"
  end

  create_table "productclas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.bigint "corder"
    t.integer "ispro"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "keyword"
  end

  create_table "productclas_products", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "productcla_id", null: false
  end

  create_table "productexplains", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "ispublic"
  end

  create_table "productexplains_products", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "productexplain_id", null: false
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "subname"
    t.float "cost"
    t.float "price"
    t.integer "onsale"
    t.text "content"
    t.integer "salecount"
    t.string "cover"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "proprice"
  end

  create_table "receiveaddrs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.string "province"
    t.string "city"
    t.string "district"
    t.string "adcode"
    t.string "address"
    t.integer "isdefault"
    t.string "contact"
    t.string "contactphone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_receiveaddrs_on_user_id"
  end

  create_table "resources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "resource_file_name"
    t.string "resource_content_type"
    t.bigint "resource_file_size"
    t.datetime "resource_updated_at"
  end

  create_table "settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "appid"
    t.string "appsecret"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "firstprofit"
    t.float "secondprofit"
    t.string "kuaidikey"
  end

  create_table "shopclas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shopclas_shops", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.bigint "shopcla_id", null: false
  end

  create_table "shopimgs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "shop_id"
    t.string "shopimg"
    t.integer "iscover"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shop_id"], name: "index_shopimgs_on_shop_id"
  end

  create_table "shops", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.decimal "lng", precision: 15, scale: 12
    t.decimal "lat", precision: 15, scale: 12
    t.string "province"
    t.string "city"
    t.string "district"
    t.string "address"
    t.string "adcode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "aliasname"
    t.float "buysum"
    t.datetime "lastbuytime"
  end

  create_table "shops_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "shopusers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "shop_id"
    t.bigint "user_id"
    t.integer "member"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shop_id"], name: "index_shopusers_on_shop_id"
    t.index ["user_id"], name: "index_shopusers_on_user_id"
  end

  create_table "showparams", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.string "showkey"
    t.string "showvalue"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "corder"
    t.index ["product_id"], name: "index_showparams_on_product_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "openid"
    t.string "unionid"
    t.string "nickname"
    t.bigint "up_id"
    t.decimal "lng", precision: 15, scale: 12
    t.decimal "lat", precision: 15, scale: 12
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token"
    t.string "headurl"
    t.index ["up_id"], name: "index_users_on_up_id"
  end

  create_table "withdrawals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.float "amount"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_withdrawals_on_user_id"
  end

end
