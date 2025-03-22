# app/models/url.rb
class Url < ApplicationRecord
  before_create :generate_shortened_url

  validates :original, presence: true, format: { with: /\Ahttps?:\/\/[\S]+\z/, message: "must be a valid URL" }

  private

  def generate_shortened_url
    self.shortened = SecureRandom.urlsafe_base64(6)  # Gera uma string aleatória de 6 caracteres
  end
end
