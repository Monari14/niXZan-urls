Rails.application.routes.draw do
  # Página inicial
  root "urls#index"

  # Rota para criar uma URL encurtada
  post '/urls', to: 'urls#create'

  # Rota para redirecionar a URL encurtada para a original
  get '/:shortened', to: 'urls#redirect', as: 'redirect_url'
end
