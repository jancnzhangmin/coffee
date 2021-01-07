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
      end
    end
    resources :banners do
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
      end
    end
  end
end
