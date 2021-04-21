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
  end

  namespace :api do
    resources :homes do
      collection do
        get 'getswiper'
        get 'getproductlist'
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
      end
    end
    resources :shops
    resources :contacts
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
  end
end
