Rails.application.routes.draw do
  root :to => 'dashboard#index'

  get 'system/ping'

  resources :dashboard

  resources :rooms do
    resources :room_sensors, only: [:index]
  end

  resources :sensors do
    resources :measurements, only: [:index, :create]
  end

  get 'sensors/:sensor_id/measurements/temperatures',
      to: 'measurements#temperature_measurements',
      constraints: lambda { |req| req.format == :json }
  post 'sensors/:sensor_id/measurements/temperatures',
       to: 'measurements#create_temperature_measurement',
       constraints: lambda { |req| req.format == :json }
  get 'sensors/:sensor_id/measurements/humidities',
      to: 'measurements#humidity_measurements',
      constraints: lambda { |req| req.format == :json }
  post 'sensors/:sensor_id/measurements/humidities',
       to: 'measurements#create_humidity_measurement',
       constraints: lambda { |req| req.format == :json }
end
