class UrlsController < ApplicationController
  # Ação para criar um novo URL curto
  def create
    # Recebe a URL original do corpo da requisição
    original_url = params[:url][:original]

    # Verifica se a URL já existe no banco de dados
    url = Url.find_by(original: original_url)

    if url
      # Se já existir, retorna a URL encurtada existente
      render json: { shortened: url.shortened }, status: :ok
    else
      # Se não existir, cria uma nova URL encurtada
      url = Url.create(original: original_url)

      if url.save
        render json: { shortened: url.shortened }, status: :created
      else
        render json: { error: "URL não pôde ser criada" }, status: :unprocessable_entity
      end
    end
  end

  # Ação para redirecionar para a URL original a partir do código curto
  def redirect
    # Encontra a URL pelo código curto
    short_url = Url.find_by(shortened: params[:shortened])

    if short_url
      # Se a URL for encontrada, redireciona para a URL original
      redirect_to short_url.original, allow_other_host: true
    else
      # Se a URL não for encontrada, retorna um erro
      render json: { error: "URL não encontrada" }, status: 404
    end
  end
end
