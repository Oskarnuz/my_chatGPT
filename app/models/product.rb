class Product < ApplicationRecord
  include ChatGPT

  def get_chatgpt_description(max_token, temperature, language)
    prompt = generate_prompt("description")  # Llamar a generate_prompt con tipo "description"
    generate_product_features(prompt, max_token, temperature, language)
  end

  def get_tags(max_token, temperature, language)
    prompt = generate_prompt("tag")  # Llamar a generate_prompt con tipo "tag"
    generate_product_features(prompt, max_token, temperature, language)
  end

  private

  def generate_prompt(type)
    I18n.locale = @language
    I18n.t "chat_gpt.#{@type}",product_name: @text.split("-")[0],text: @text.split("-")[1]
  end

  def generate_product_features(prompt, max_token, temperature, language)
    response = complete_prompt(prompt, max_token, temperature, language)
    extract_response_text(response)
  end

  def complete_prompt(prompt, max_token, temperature, language)
    openai_client.completions(
      parameters: {
        model: SUPPORTED_LANGUAGES[language],
        prompt: prompt,
        max_tokens: max_token,
        temperature: temperature
      }
    )
  end

end