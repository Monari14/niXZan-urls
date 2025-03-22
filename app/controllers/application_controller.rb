# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Desabilita a verificação de CSRF apenas para APIs
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
end
