class QuestionsChannel < ApplicationCable::Channel
  def echo(data)
    transmit data
  end
end
