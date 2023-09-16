Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do 
    
    namespace :v1 do 

      namespace :admin do 
        post '/auth', to: 'authentication#create'
        resources :schedules 
        resources :bookings
        resources :contact_informations
        resources :online_links 
        resources :tentative_lineups
      end  

      namespace :guest do 
        resources :schedules, only: [:index, :show]
        resources :bookings, only: [:create]
      end

    end 
  end
    

end
