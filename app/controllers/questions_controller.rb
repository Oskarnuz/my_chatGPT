class QuestionsController < ApplicationController
  def index
  end

  def create
    question_text = question # Obtener la pregunta desde el método privado

    # Crear una instancia de AnswerQuestion y llamar a `call` para obtener la respuesta
    answer = AnswerQuestion.new(question_text).call

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("answer", partial: "answers/answer", locals: { answer: answer })
      end
    end
  end

  private

  def question
    params[:question][:question]
  end
  
end