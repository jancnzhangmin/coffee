Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :admin do
    resources :settings
    resources :products do
      resources :productbanners
      resources :showparams do
        collection do
          post 'sort'
        end
      end
      resources :posters do
        collection do
          post 'updatecontent'
        end
      end
      resources :buyparams do
        collection do
          post 'sort'
        end
        resources :buyparamvalues do
          collection do
            post 'sort'
          end
        end
      end
    end
    resources :resources
    resources :productclas do
      collection do
        get 'getproducts'
        post 'sort'
        post 'checkkeyword'
      end
    end
    resources :banners do
      collection do
        post 'sort'
      end
    end
    resources :imgresources
    resources :changedomains
    resources :orders do
      collection do
        post 'judge_express'
        post 'deletedeliver'
      end
    end
    resources :productexplains
    resources :agentlevels do
      collection do
        post 'sort'
      end
    end
    resources :mytests
    resources :profits
    resources :expresscodes
    resources :publicmethods do
      collection do
        get 'get_today'
        get 'get_yesterday'
        get 'get_week'
        get 'get_month'
        get 'get_quarter'
        get 'get_year'
        get 'get_lastyear'
        get 'get_nearday'
        get 'get_nearweek'
        get 'get_nearmonth'
      end
    end
    resources :users do
      collection do
        get 'getupuser'
        post 'setupuser'
      end
    end
    resources :shopfirsts do
      collection do
        get 'getproduct'
      end
      resources :shopfirstdetails
    end
    resources :contracttemplates
    resources :hotsales do
      collection do
        post 'sort'
      end
    end
  end

  namespace :api do
    resources :homes do
      collection do
        get 'getswiper'
        get 'getproductlist'
        get 'gethotsales'
      end
    end
    resources :productlists do
      collection do
        get 'getproductclas'
        get 'getproductlists'
      end
    end
    resources :buycars
    resources :users do
      collection do
        get 'getuserinfo'
        get 'getaddrs'
        get 'getaddr'
        post 'createaddr'
        post 'updateaddr'
        delete 'deleteaddr'
      end
    end
    resources :orders do
      collection do
        post 'createorder'
        get 'getorders'
        post 'deleteorder'
      end
    end
    resources :shops do
      collection do
        get 'getcurrentshop'
        post 'setdefault'
        get 'getshopaddress'
        post 'setshopaddress'
        get 'get_shopqr'
      end
    end
    resources :contacts do
      collection do
        post 'checkrepeat'
        post 'deletecontract'
      end
    end
    resources :productdetails
    resources :cooperstores
    resources :cooperstoredetails do
      collection do
        get 'getdirectorlist'
        post 'setdirector'
      end
    end
    resources :teams
    resources :stayincomes
    resources :finances do
      collection do
        get 'get_financeing'
        get 'get_financearea'
        get 'get_financelist'
      end
    end
    resources :claproducts
    resources :logins do
      collection do
        post 'updateinfo'
        post 'setlocation'
      end
    end
    resources :posters do
      collection do
        get 'getwxacodeunlimit'
      end
    end
    resources :shopoverviews
    resources :shoporders
    resources :incomes
    resources :upgradeconditions
    resources :wxquery do
      collection do
        post 'shopmanager'
        post 'shopcustomer'
        post 'upuser'
      end
    end
    resources :delivers do
      collection do
        post 'confirmdeliver'
      end
    end
    resources :wxpay do
      collection do
        post 'prepay'
        post 'wxpay_notify'
      end
    end
    resources :evaluates
    resources :coopersign do
      collection do
        post 'createcode'
        get 'contractpreview'
        post 'createsign'
      end
    end
  end
  resources :polldeliver
  resources :mytest
  require 'sidekiq/web'
  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"
  mount Sidekiq::Web => '/sidekiq'
end
