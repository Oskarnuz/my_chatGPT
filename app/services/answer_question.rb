class AnswerQuestion
  attr_reader :question

  def initialize(question)
    @question = question
  end

  def call
    message_to_chat_api(<<~CONTENT)
      Answer the question based on the context below, and
      if the question can't be answered based on the context,
      say \"I don't know\".

      Context:
      #{context}

      ---

      Question: #{question}
    CONTENT
  end

  private

  def message_to_chat_api(message_content)
    response = openai_client.chat(parameters: {
      model: 'gpt-3.5-turbo',
      messages: [{ role: 'user', content: message_content }],
      temperature: 0.5
    })
    response.dig('choices', 0, 'message', 'content')
  end

  def context
    question_embedding = embedding_for(question)
    nearest_items = Item.nearest_neighbors(
      :embedding, question_embedding,
      distance: "euclidean"
    )
    
    if nearest_items.first
      context = nearest_items.first.text
    else
      context = "<<~LONGTEXT
      RubyroidLabs custom software development services. We can build a website, web application, or mobile app for you using Ruby on Rails. We can also check your application for bugs, errors and inefficiencies as part of our custom software development services.
    
      Services:
      * Ruby on Rails development. Use our Ruby on Rails developers in your project or hire us to review and refactor your code.
      * CRM development. We have developed over 20 CRMs for real estate, automotive, energy and travel companies.
      * Mobile development. We can build a mobile app for you that works fast, looks great, complies with regulations and drives your business.
      * Dedicated developers. Rubyroid Labs can boost your team with dedicated developers mature in Ruby on Rails and React Native, UX/UI designers, and QA engineers.
      * UX/UI design. Rubyroid Labs can create an interface that will engage your users and help them get the most out of your application.
      * Real estate development. Rubyroid Labs delivers complex real estate software development services. Our team can create a website, web application and mobile app for you.
      * Technology consulting. Slash your tech-related expenses by 20% with our help. We will review your digital infrastructure and audit your code, showing you how to optimize it.
    LONGTEXT"
    end
  end

  def embedding_for(text)
    response = openai_client.embeddings(
      parameters: {
        model: 'text-embedding-ada-002',
        input: text
      }
    )
  

    response.dig('data', 0, 'embedding')
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new
  end
end

# AnswerQuestion.new("Yours question..").call