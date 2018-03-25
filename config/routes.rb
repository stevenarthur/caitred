Cake::Application.routes.draw do

  # Redirections from V2
  get "/contact_us", to: redirect("/contact-us")
  get "/about_us", to: redirect("/about-us")
  
  get "in/:locality", to: redirect("/our-caterers/in/%{locality}")
  get "in/:locality/search", to: redirect("/our-caterers/in/%{locality}/search")
  # End Redirections

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Admin Routes
  namespace :admin do
    resources :enquiries do
      post :set_address
      get :enquiry_address, as: 'address'
      post :regress
      post :send_confirmation_link
    end

    resources :quotes
    resources :testimonials

    # Used to progress a customers cart to an enquiry.
    resources :carts, only: [:index] do
      member do
        post :make_enquiry
      end
    end

    # TODO: refactor these
    get 'customer/:id/enquiry', to: 'enquiries#new_for_customer', as: 'create_enquiry_for_customer'
    post 'enquiries/:id/progress', to: 'enquiries#progress', as: 'progress_enquiry'
    post 'enquiries/:id/spam', to: 'enquiries#spam', as: 'mark_enquiry_as_spam'
    post 'enquiries/:id/test', to: 'enquiries#test', as: 'mark_enquiry_as_test'
    post 'enquiries/:enquiry_id/send_supplier_email', to: 'supplier_communications#create', as: 'send_supplier_order'
    post 'enquiries/:id/cancel', to: 'enquiries#cancel', as: 'cancel_enquiry'
    post 'enquiries/:id/refund', to: 'enquiries#refund', as: 'refund_enquiry'
    post 'enquiries/:enquiry_id/generate_invoice', to: 'invoice#create', as: 'generate_invoice'
    get 'enquiries/:id/invoice', to: 'enquiries#invoice', as: 'enquiry_invoice'
    get 'enquiries/update_extras/:id', to: 'enquiries#update_extras', as: ''
    get 'enquiries/confirm_enquiry/:id', to: 'enquiries#confirm_enquiry', as: 'enquiry_confirm'

    resources :customers do
      resources :addresses, except: [:index] do
        post :set_default
      end
      get :enquiries, to: 'customers#enquiries', as: 'enquiries'
    end

    # resources :polls, except: [:delete]
    namespace :menu_tags do
      get '/', action: :index
      post :generate_tags
      post :save_all
    end

    namespace :reports do
      get :index
      get :completed_orders
      get :monthly
      get :weekly
      get :customers
    end

    post 'supplier_comms/incoming', to: 'incoming_mail#from_supplier'

  end

  scope '/admin' do
    resources :orders
    resources :food_partners, except: [:show] do
      member do
        post :add_postcode
        delete :remove_postcode
      end
    end
    scope '/food_partners/:food_partner_id' do
      resources :packageable_items, except: [:show]
      resources :menu_categories, except: [:show]
    end

    get :login, to: 'admin_user_sessions#new'
    post :login, to: 'admin_user_sessions#create', as: 'create_user_session'
    get :logout, to: 'admin_user_sessions#destroy'

    post 'login_as_customer/:id', to: 'admin/customer_logins#create', as: 'login_as_customer'

    get :users, to: 'admin_users#index'
    get 'users/new', to: 'admin_users#new', as: 'new_user'
    post 'users/new', to: 'admin_users#create', as: 'create_user'

    get 'users/myprofile',
        to: 'admin_users#edit_my_profile',
        as: 'edit_my_profile'
    get 'users/password',
        to: 'admin_users#reset_my_password',
        as: 'reset_my_password'

    delete 'users/:id', to: 'admin_users#destroy', as: 'destroy_user'
    get 'users/:id', to: 'admin_users#edit', as: 'edit_profile'
    get 'users/:id/password',
        to: 'admin_users#reset_password',
        as: 'reset_password'
    patch 'users/:id', to: 'admin_users#update'
    get 'credits', to: 'admin/static_content#admin_credits'
  end

  # Redirections
  get '/contacts', to: redirect('/share_contest')
  get '/sell-with-us', to: redirect('/sell-your-catering-with-us'), as: 'sell_with_us_old'
  get '/sell_with_us', to: redirect('/sell-with-us'), as: 'sell_with_us_old_old'
  get '/sell_with_us_thanks', to: redirect('/sell-with-us-thanks')

  # Postcode search
  get '/our-caterers/in/(:locality)', to: 'web/search#show', as: 'partner_search'
  get '/our-caterers/in/:locality/search', to: 'web/search#search', as: 'partner_advanced_search'
  post '/search', to: 'web/search#create', as: 'partners_in_postcode_search'
  put '/update_enquiry_parameters', to: 'web/search#update_enquiry_parameters', as: 'update_enquiry_parameters'

  # Enquiry Items Create & Destroy
  post '/cart', to: 'web/enquiry_items#create', as: 'add_cart_item'
  post '/cart-package', to: 'web/enquiry_items#add_package', as: 'add_cart_package'
  delete '/cart-package/:id', to: 'web/enquiry_items#remove_package', as: 'remove_cart_package'
  delete '/cart/:id', to: 'web/enquiry_items#destroy', as: 'remove_cart_item'
  post '/cart/:id/clear', to: 'web/enquiry_items#clear', as: 'clear_cart_items'

  #get '/auth/:provider/callback', to: 'web/omniauth_callbacks#linkedin'

  get '/munchabetterlunch', to: 'welcome#contest', as: 'contest'
  get '/share_contest', to: 'welcome#share', as: 'share_contest'
  post '/contacts', to: 'contacts#create'

  post '/autocomplete/postcodes', to: 'welcome#postcode_lookup', as: "postcode_lookup"
  root 'welcome#index'

  get 'faqs', to: 'web/static_content#faqs'
  get 'terms', to: 'web/static_content#terms'
  get 'privacy', to: 'web/static_content#privacy'
  get 'terms-of-service', to: 'web/static_content#terms_of_service'
  get 'contact-us', to: 'web/static_content#contact_us'
  get 'about-us', to: 'web/static_content#about_us'
  get 'about-elizabeth', to: 'web/static_content#about_elizabeth'

  get 'caitredette-service', to: redirect('caitredette-catering-service'), as: 'caitredette_service_old'
  get 'caitredette-catering-service', to: 'web/caitredette_service_requests#new', as: 'caitredette_service'

  # Sell with us
  get 'sell-your-catering-with-us', to: 'web/static_content#sell_with_us', as: 'sell_with_us'
  post 'sell-your-catering-with-us', to: 'web/new_supplier#new_supplier_enquiry'
  get 'sell-with-us-thanks', to: 'web/new_supplier#thanks'

  get 'my-account', to: 'web/customers#my_account'

  get 'enquiries/:enquiry_id/supplier_confirmation/:token', to: 'web/enquiries#supplier_confirmation', as: 'supplier_order_confirmation'
  get 'enquiries/:enquiry_id/supplier_refusal/:token', to: 'web/enquiries#supplier_refusal', as: 'supplier_order_refusal'
  get 'enquiries/fail_identify', to: "web/enquiries#supplier_fail", as: 'supplier_fail'
  
  post '/t_callbacks', to: "web/enquiries#sms_reply"
  
  get 'catering-quote', to: 'web/quotes#new'
  get 'catering-quote/submitted', to: 'web/quotes#submitted', as: 'submitted_quote'
  get 'quotes/new', to: redirect('catering-quote')
  get 'quotes/submitted', to: redirect('catering-quote/submitted')

   get 'partners',
      to: 'web/food_partners#index',
      as: 'partners_from_web'

    get 'partners/:slug',
      to: 'web/food_partners#show',
      as: 'partner_from_web'

   get 'partners/:slug/information',
      to: 'web/food_partners#information',
      as: 'partners_from_web_information'

   post 'partners/:slug/checkout',
      to: 'web/checkout#new',
      as: 'partner_checkout'

   patch 'partners/:slug/payment',
      to: 'web/checkout#payment',
      as: 'payment'

   post 'partners/:slug/purchase',
      to: 'web/checkout#create',
      as: 'purchase'

   patch 'partners/:slug/purchase',
      to: 'web/checkout#create'

   get 'thanks', to: 'web/checkout#thanks', as: 'thanks'


  get 'olivers-page', to: 'welcome#oliver', as: 'olivers_path'

  resources :postcode_leads, only: :create
  resources :investment_leads, only: :create

  scope module: 'web' do
    resources :caitredette_service_requests, only: [:create]
    resources :quotes
    resources :testimonials
    get '/subscribers/new', to: 'subscribers#create', as: 'new_subscriber'
    get '/subscribers/success', to: 'subscribers#success', as: 'success_subscriber'
    resources :password_reset, only: [:new, :create]

    get 'enquiries/confirm/:token', to: 'enquiry_confirmation#new', as: 'ready_to_confirm'
    post 'enquiries/confirm', to: 'enquiry_confirmation#create', as: 'confirm_enquiry'
    get 'enquiries/confirmed', to: 'enquiry_confirmation#confirmed', as: 'enquiry_confirmed'
    get 'enquiries/confirmation/regenerate', to: 'enquiry_confirmation#regenerate', as: 'regenerate_enquiry_confirmation'

    # post 'poll/:id/vote', to: 'polls#vote', as: 'vote_on_poll'
    # get 'poll/:id/results', to: 'polls#results', as: 'poll_results'
  end

  patch 'customers/:id/create_account', to: 'web/customers#create_account', as: 'create_account'
  get 'login', to: 'web/customer_sessions#new', as: 'customer_login'
  post 'login', to: 'web/customer_sessions#create'
  get 'logout', to: 'web/customer_sessions#destroy', as: 'customer_logout'
  get 'register', to: 'web/customers#new', as: 'register'
  post 'register', to: 'web/customers#create', as: 'create_registration'
  get 'my-profile', to: 'web/customers#edit', as: 'edit_customer'
  patch 'my-profile', to: 'web/customers#update', as: 'update_customer'
  get 'reset_password', to: 'web/customers#reset_password', as: 'reset_customer_password'
  post 'reset_password', to: 'web/customers#do_reset_password', as: 'do_reset_customer_password'
  get 'my-account/order/invoice/:id', to: 'web/enquiries#invoice', as: 'web_enquiry_invoice'

  mount Judge::Engine => '/judge'
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
end
