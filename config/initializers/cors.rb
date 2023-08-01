Rails.application.config.middleware.insert_before 0, Rack::Cors do
  
  allow do
    origins '*'
    resource '/api/*', headers: :any, methods: [:get, :post, :patch, :put]
    resource '/rails/active_storage/*', headers: :any, methods: [:get]
  end

end
