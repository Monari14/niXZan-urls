class UrlsController < ApplicationController
  # Ação para criar um novo URL curto
  def create
    # Recebe a URL original do corpo da requisição
    original_url = params[:url][:original]

    # Adiciona "https://" se a URL não começar com "http://" ou "https://"
    unless original_url.match(/^https?:\/\//)
      original_url = "https://#{original_url}"
    end

    # Verifica se a URL começa com http:// e substitui por https://
    original_url = original_url.sub(/^http:\/\//, 'https://')

    # Verifica se a URL já existe no banco de dados
    url = Url.find_by(original: original_url)

    if url
      # Se já existir, retorna a URL encurtada e o QR Code
      render json: { shortened: url.shortened, qr_code: generate_qr_code(url.shortened) }, status: :ok
    else
      # Se não existir, cria uma nova URL encurtada
      url = Url.create(original: original_url)

      if url.save
        # Gerar o QR Code para a URL encurtada
        qr_code = generate_qr_code(url.shortened)
        
        # Adicionando um log para verificar os dados
        Rails.logger.debug "Shortened URL: #{url.shortened}, QR Code: #{qr_code}"

        render json: { shortened: url.shortened, qr_code: qr_code }, status: :created
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

  private

  # Método para gerar o QR Code para a URL encurtada
  def generate_qr_code(shortened_url)
    qr = RQRCode::QRCode.new(shortened_url)

    # Gera a imagem do QR Code em formato PNG e retorna como URL de dados
    qr.as_png(size: 300).to_data_url
  end
end
