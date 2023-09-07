module ChatGpt
  extend ActiveSupport::Concern

  included do
    def get_chatgpt_description(max_token, temperature, language)
      text = "#{name}-#{description}"
      service = AnswerCompletion.new(text, max_token, temperature, language, "description")
      result = service.call      
    end
      
    def get_tags(max_token, temperature, language)
      text = "#{name}-#{description}"
      service = AnswerCompletion.new(text, max_token, temperature, language, "tag")
      result = service.call      
    end
  end
end