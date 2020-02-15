class SubscriptionsController < ApplicationController
  skip_authorization_check

  expose :question, -> { Question.find(params[:question_id]) }
  expose :subscription, -> { current_user&.subscriptions.where(question_id: params[:question_id]).first }

  def subscribe
    # byebug
    return unless current_user

    if subscription
      subscription.destroy
    else
      question.subscriptions.create(user: current_user)
    end

    head :no_content
  end

end
