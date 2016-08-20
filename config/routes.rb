Rails.application.routes.draw do
  root :to => 'dashboard#index'

  get 'dashboard', to: 'dashboard#index', as: :dashboard
  patch 'dashboard/system_settings/:id', to: 'dashboard#update_system_settings', as: :update_system_settings

  get 'system/ping'

  get 'rooms/:room_id/measurements/temperatures', to: 'measurements#temperature_measurements',
      constraints: lambda { |req| req.format == :json }
  get 'rooms/:room_id/sensors/:sensor_id/measurements/temperatures', to: 'measurements#temperature_measurements',
      constraints: lambda { |req| req.format == :json }
  get 'sensors/:sensor_id/measurements/temperatures', to: 'measurements#temperature_measurements',
      constraints: lambda { |req| req.format == :json }
  post 'sensors/:sensor_id/measurements/temperatures', to: 'measurements#create_temperature_measurement',
       constraints: lambda { |req| req.format == :json }
  get 'rooms/:room_id/measurements/humidities', to: 'measurements#humidity_measurements',
      constraints: lambda { |req| req.format == :json }
  get 'rooms/:room_id/sensors/:sensor_id/measurements/humidities', to: 'measurements#humidity_measurements',
      constraints: lambda { |req| req.format == :json }
  get 'sensors/:sensor_id/measurements/humidities', to: 'measurements#humidity_measurements',
      constraints: lambda { |req| req.format == :json }
  post 'sensors/:sensor_id/measurements/humidities', to: 'measurements#create_humidity_measurement',
       constraints: lambda { |req| req.format == :json }

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
