module Voted
  extend ActiveSupport::Concern
  STRONG_PARAMS = %i[ :vote ].freeze

  included do
    before_action :set_votable, only: :vote
  end

  def vote
    respond_to do |format|
      if current_user.author_of?(@votable)
        format.json { render json: { errors: "#{@votable.class}-author cannot vote" }, status: :unprocessable_entity }
      else
        vote = Vote.find_or_initialize_by(author: current_user, votable: @votable)
        vote.voting(params[:vote])
        format.json { render json: { rating: "#{@votable.rating}" } }
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
