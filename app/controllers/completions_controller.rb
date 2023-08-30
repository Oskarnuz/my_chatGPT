# app/controllers/completions_controller.rb

class CompletionsController < ApplicationController
  # Este para omitir la verificación del token de autenticidad en las solicitudes entrantes
  skip_before_action :verify_authenticity_token

  # Hash que relaciona códigos de idioma con los modelos de lenguaje en la API de OpenAI
  SUPPORTED_LANGUAGES = {
    "en" => "text-davinci-001",
    "es" => "text-davinci-002"
  }

  def show
    language = params[:language] || "en"
  end

  # Se define el metodo para manejar solicitudes POST de generación de completions
  def create
    # Se extraen los parámetros de la solicitud POST
    input_text = params[:input_text]       # Texto proporcionado por el usuario
    max_token = params[:max_token]         # Máximo número de tokens en la respuesta
    temperature = params[:temperature]     # Valor para controlar la aleatoriedad
    language = params[:language] || "en"   # Idioma de la solicitud (por defecto, inglés)
    type = params[:type] #Requerimiento

    unless SUPPORTED_LANGUAGES.include?(language)
      render json: { error: "Idioma no compatible" }, status: :unprocessable_entity
      return
    end

    # Se crea una instancia de la clase AnswerCompletion con los parámetros proporcionados
    service = AnswerCompletion.new(input_text, max_token, temperature, language, type)

    # Se llama al método call en la instancia, el cual realiza la llamada a la API de OpenAI
    response = service.call

    # Se devuelve la respuesta generada en formato JSON como respuesta a la solicitud
    render json: { response: response }
  end

  private

  def generate_completion(prompt, max_token, temperature, language, type)
    openai_client = OpenAI::Client.new

    # Se realiza la solicitud de complettions utilizando los parámetros proporcionados
    response = openai_client.completions(
      engine: SUPPORTED_LANGUAGES[language],  # Modelo de lenguaje según el idioma
      prompt: prompt,                         # El prompt proporcionado para la completion
      max_tokens: max_token,                  # Longitud máxima de la respuesta generada
      temperature: temperature,                # Valor para controlar la aleatoriedad
      # type: type
    )

    # Extrer el texto de la primera opción de respuesta
    response.choices[0].text.strip
  end
end
