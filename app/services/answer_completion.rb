class AnswerCompletion
  # Hash que relaciona códigos de idioma con los modelos de lenguaje en la API de OpenAI
  SUPPORTED_LANGUAGES = {
    "en" => "English",
    "es" => "Spanish"
  }

  # Constructor de la clase, inicializa los atributos con los valores proporcionados
  def initialize(text, max_token, temperature, language, type)
    @text = text  # El texto del producto proporcionado
    @max_token = max_token.to_i  # La longitud máxima del resultado generado
    @temperature = temperature.to_f  # VAlor que afecta la aleatoriedad del resultado
    @language = language  # El idioma en el que se generará la respuesta
    @type = type
  end

  # Método principal que se llama para generar completions
  def call
    prompt = generate_prompt  # Generar el texto del prompt a partir de los atributos
    generate_product_features(prompt)  # Generar características del producto usando el prompt
  end

  private

  # Genera el prompt que se enviará a la API de OpenAI
  def generate_prompt
    I18n.locale = @language
    I18n.t "chat_gpt.#{@type}",product_name: @text.split("-")[0],text: @text.split("-")[1]
  end

  # Genera las características del producto utilizando el prompt generado
  def generate_product_features(prompt)
    response = complete_prompt(prompt)  # Realiza la solicitud a la API de OpenAI
    extract_response_text(response)  # Extrae el texto de respuesta de la API
  end

  # Realiza la solicitud a la API de OpenAI para completar el prompt
  def complete_prompt(prompt)
    openai_client.completions(
      parameters: {
        model: "text-davinci-001",
        prompt: prompt,
        max_tokens: @max_token,
        temperature: @temperature,
      }
    )
  end

  # Extrae y devuelve el texto de respuesta de la API
  def extract_response_text(response)
    response["choices"].map { |c| c["text"] }
  end

 

  # Crea y devuelve una instancia del cliente de OpenAI
  def openai_client
    @openai_client ||= OpenAI::Client.new
  end
end
