class SubscriptionsController < ApplicationController

  before_action :authenticate_user!

  expose :question, -> { Question.find_by(id: params[:question_id]) }
  expose :subscription, -> { question ? current_user&.get_sub_on_question(question) : nil }


  def create
    authorize! :create, Subscription
    return head(:unprocessable_entity) unless question
    subscription = question.subscriptions.new(user: current_user)

    if subscription.save
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, Subscription
    if subscription&.destroy
      head :no_content
    else
      head :unprocessable_entity
    end
  end

end
