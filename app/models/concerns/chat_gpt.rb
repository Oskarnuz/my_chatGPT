# module ChatGPT
#   extend ActiveSupport::Concern

#   included do
#     def get_chatgpt_description(max_token, temperature, language)
#       prompt = generate_prompt("description")  # Llamar a generate_prompt con tipo "description"
#       generate_product_features(prompt, max_token, temperature, language)
#     end
      
#     def get_tags
#       prompt = generate_prompt("tag")  # Llamar a generate_prompt con tipo "tag"
#       generate_product_features(prompt, max_token, temperature, language)
#     end
#   end
# end

# app/models/concerns/chat_gpt.rb

module ChatGPT
  extend ActiveSupport::Concern

  SUPPORTED_LANGUAGES = {
    "en" => "text-davinci-001",
    "es" => "text-davinci-002"
  }

  included do
    private

    def extract_response_text(response)
      choices = response["choices"] || []
      choices.map { |c| c["text"] }
    end

    def openai_client
      @openai_client ||= OpenAI::Client.new
    end
  end
end
