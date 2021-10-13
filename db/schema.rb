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

ActiveRecord::Schema.define(version: 2021_10_06_022942) do

  create_table "accesstokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "accesstoken"
    t.integer "expiresin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "login"
    t.string "password_digest"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "aftersaleimgs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "aftersaleimg_id"
    t.string "aftersaleimg"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "aftersale_id"
    t.index ["aftersaleimg_id"], name: "index_aftersaleimgs_on_aftersaleimg_id"
  end

  create_table "aftersales", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "order_id"
    t.string "contact"
    t.string "summary"
    t.string "reply"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_aftersales_on_order_id"
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

  create_table "buycarparams", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "buycar_id"
    t.string "buyparam"
    t.bigint "buyparam_id"
    t.string "buyparamvalue"
    t.bigint "buyparamvalue_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buycar_id"], name: "index_buycarparams_on_buycar_id"
    t.index ["buyparam_id"], name: "index_buycarparams_on_buyparam_id"
    t.index ["buyparamvalue_id"], name: "index_buycarparams_on_buyparamvalue_id"
  end

  create_table "buycars", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "user_id"
    t.float "number"
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "proprice"
    t.integer "producttype"
    t.string "activesummary"
    t.string "cover"
    t.index ["product_id"], name: "index_buycars_on_product_id"
    t.index ["user_id"], name: "index_buycars_on_user_id"
  end

  create_table "buyfullactivedetails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "buyfullactive_id"
    t.integer "buynumber"
    t.integer "givenumber"
    t.bigint "giveproduct_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyfullactive_id"], name: "index_buyfullactivedetails_on_buyfullactive_id"
  end

  create_table "buyfullactives", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "nametag"
    t.datetime "begintime"
    t.datetime "endtime"
    t.string "summary"
    t.string "cover"
    t.float "price"
    t.bigint "product_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "buyparams", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.string "param"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "corder"
    t.index ["product_id"], name: "index_buyparams_on_product_id"
  end

  create_table "buyparamvalues", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "buyparam_id"
    t.string "cover"
    t.string "name"
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "corder"
    t.float "cost"
    t.index ["buyparam_id"], name: "index_buyparamvalues_on_buyparam_id"
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

  create_table "contracttemplates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "contracttemplate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "evaluateimgs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "evaluate_id"
    t.string "evaluateimg"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["evaluate_id"], name: "index_evaluateimgs_on_evaluate_id"
  end

  create_table "evaluates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.float "speed"
    t.float "quality"
    t.text "summary"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "describe"
    t.integer "systemstatus"
    t.index ["user_id"], name: "index_evaluates_on_user_id"
  end

  create_table "evaluates_products", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "evaluate_id", null: false
    t.bigint "product_id", null: false
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

  create_table "hotsales", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "corder"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_hotsales_on_product_id"
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

  create_table "invoicedefs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "duty"
    t.string "address"
    t.string "tel"
    t.string "bank"
    t.string "account"
    t.string "mail"
    t.integer "invoicetype"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "isdefault"
    t.index ["user_id"], name: "index_invoicedefs_on_user_id"
  end

  create_table "jobmonitors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "param"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lives", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "roomid"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mpaccesstokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "accesstoken"
    t.integer "expiresin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mpexplains", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.bigint "corder"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mpmaterials", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "mediaid"
    t.string "title"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mediaid"], name: "index_mpmaterials_on_mediaid"
  end

  create_table "mpusers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "openid"
    t.string "unionid"
    t.string "nickname"
    t.string "headurl"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "subscribe"
  end

  create_table "orderdelivers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "order_id"
    t.string "com"
    t.string "nu"
    t.text "cdata"
    t.string "company"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "state"
    t.index ["order_id"], name: "index_orderdelivers_on_order_id"
  end

  create_table "orderdetailparams", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "orderdetail_id"
    t.string "buyparam"
    t.bigint "buyparam_id"
    t.string "buyparamvalue"
    t.bigint "buyparamvalue_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["orderdetail_id"], name: "index_orderdetailparams_on_orderdetail_id"
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

  create_table "orderinvoices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "order_id"
    t.string "name"
    t.string "duty"
    t.string "address"
    t.string "tel"
    t.string "account"
    t.string "mail"
    t.integer "invoicetype"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "processed"
    t.string "bank"
    t.index ["order_id"], name: "index_orderinvoices_on_order_id"
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
    t.bigint "shop_id"
    t.datetime "delivertime"
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
    t.integer "pv"
    t.integer "startnumber"
    t.float "speed"
    t.float "quality"
    t.float "describe"
    t.float "comp"
    t.integer "retailstartnumber"
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
    t.string "resourceurl"
  end

  create_table "settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "appid"
    t.string "appsecret"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "firstprofit"
    t.float "secondprofit"
    t.string "kuaidikey"
    t.string "qrcode"
    t.integer "autoreceive"
    t.integer "autoevaluate"
    t.string "mpappid"
    t.string "mpappsecret"
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

  create_table "shopfirstdetails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "shopfirst_id"
    t.bigint "buyproduct_id"
    t.integer "buynumber"
    t.bigint "giveproduct_id"
    t.integer "givenumber"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shopfirst_id"], name: "index_shopfirstdetails_on_shopfirst_id"
  end

  create_table "shopfirsts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "begintime"
    t.datetime "endtime"
    t.integer "status"
    t.string "summary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.string "license"
    t.string "contractnumber"
    t.integer "contractstatus"
    t.string "cover"
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

  create_table "singlediscounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.string "name"
    t.integer "buynumber"
    t.float "discount"
    t.datetime "begintime"
    t.datetime "endtime"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_singlediscounts_on_product_id"
  end

  create_table "teamorderids", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "order_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.bigint "shopdefaultid"
    t.float "salesum"
    t.integer "salecount"
    t.integer "peoplecount"
    t.integer "mancount"
    t.integer "directorcount"
    t.integer "managercount"
    t.index ["up_id"], name: "index_users_on_up_id"
  end

  create_table "withdrawals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.float "amount"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ordernumber"
    t.index ["user_id"], name: "index_withdrawals_on_user_id"
  end

end
