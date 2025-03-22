# config/routes.rb
Rails.application.routes.draw do
  # Rota para criar a URL encurtada
  post '/urls', to: 'urls#create'

  # Rota para redirecionar a URL encurtada para a original
  get '/:shortened', to: 'urls#redirect'
end
