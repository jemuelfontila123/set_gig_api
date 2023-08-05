Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do 
    
    namespace :v1 do 

      namespace :admin do 
        post '/auth', to: 'authentication#create'
        resources :schedules 
        resources :bookings 
        resources :contact_informations, only: [:show, :update, :destroy] 

      end 

    end 
  end
    

end
