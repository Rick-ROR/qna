class SubscriptionsController < ApplicationController

  before_action :authenticate_user!

  expose :question, -> { Question.find(params[:question_id]) }
  expose :subscription, -> { current_user&.get_sub_on_question(question) }

  def subscribe
    authorize! :subscribe, Subscription

    if subscription
      subscription.destroy
    else
      question.subscriptions.create!(user: current_user)
    end

    head :no_content
  end

end
