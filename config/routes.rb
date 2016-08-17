Rails.application.routes.draw do
  root :to => 'dashboard#index'

  get 'dashboard', to: 'dashboard#index', as: :dashboard

  get 'system/ping'

  get 'sensors/:sensor_id/measurements/temperatures', to: 'measurements#temperature_measurements',
      constraints: lambda { |req| req.format == :json }
  post 'sensors/:sensor_id/measurements/temperatures', to: 'measurements#create_temperature_measurement',
       constraints: lambda { |req| req.format == :json }
  get 'sensors/:sensor_id/measurements/humidities', to: 'measurements#humidity_measurements',
      constraints: lambda { |req| req.format == :json }
  post 'sensors/:sensor_id/measurements/humidities', to: 'measurements#create_humidity_measurement',
       constraints: lambda { |req| req.format == :json }

  resources :dashboard, only: [:index]

  resources :rooms do
    resources :sensors, controller: :room_sensors, only: [:index, :show] do
      resources :measurements, only: [:index, :show], constraints: lambda { |req| req.format == :json }
    end
  end

  resources :sensors do
    resources :measurements, only: [:index, :show], constraints: lambda { |req| req.format == :json }
  end

  resources :programs do
    resources :schedules, only: [:new, :create, :edit, :update, :destroy], constraints: lambda { |req| req.format == :html }
    resources :schedules, only: [:index, :show], constraints: lambda { |req| req.format == :json }
  end
end
