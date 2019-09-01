class QuestionsChannel < ApplicationCable::Channel
  def tell_me(data)
    Rails.logger.info data
  end
end
