Rails.application.routes.draw do

  resources :editors
  resources :papers do
    member do
      post 'start_review'
      post 'start_meta_review'
      post 'reject'
      post 'withdraw'
    end

    collection do
      get 'recent'
      get 'published', to: 'papers#popular'
      get 'active'
      get 'filter', to: 'papers#filter'
    end
  end

  get '/papers/lookup/:id', :to => "papers#lookup"
  get '/papers/in/:language', to: "papers#filter", as: 'papers_by_language'
  get '/papers/by/:author', to: "papers#filter", as: 'papers_by_author'
  get '/papers/tagged/:tag', to: "papers#filter", as: 'papers_by_tag'
  get '/papers/issue/:issue', to: "papers#filter", as: 'papers_by_issue'
  get '/papers/volume/:volume', to: "papers#filter", as: 'papers_by_volume'
  get '/papers/year/:year', to: "papers#filter", as: 'papers_by_year'
  get '/papers/:id/status.svg', :to => "papers#status", :format => "svg", :as => 'status_badge'
  get '/papers/:doi/status.svg', :to => "papers#status", :format => "svg", :constraints => { :doi => /10.21105\/joss\.\d{5}/}
  get '/papers/:doi', :to => "papers#show", :constraints => {:doi => /.*/}

  get '/dashboard/all', :to => "home#all"
  get '/dashboard/incoming', :to => "home#incoming"
  get '/dashboard/in_progress', :to => "home#in_progress"
  get '/dashboard', :to => "home#dashboard"

  get '/dashboard/*editor', :to => "home#reviews"

  post '/update_profile', :to => "home#update_profile"
  get '/about', :to => 'home#about', :as => 'about'
  get '/profile', :to => 'home#profile', :as => 'profile'
  get '/auth/:provider/callback', :to => 'sessions#create'
  get "/signout" => "sessions#destroy", :as => :signout

  get '/blog' => redirect("http://blog.joss.theoj.org"), :as => :blog
  # API methods
  post '/papers/api_start_review', :to => 'dispatch#api_start_review'
  post '/papers/api_deposit', :to => 'dispatch#api_deposit'
  post '/papers/api_assign_editor', :to => 'dispatch#api_assign_editor'
  post '/papers/api_assign_reviewers', :to => 'dispatch#api_assign_reviewers'
  post '/dispatch', :to => 'dispatch#github_recevier', :format => 'json'

  root :to => 'home#index'
end
