class SearchController < ApplicationController
  skip_authorization_check

  def result
    # byebug
    @results = ThinkingSphinx.search ThinkingSphinx::Query.escape(params[:query])
  end
end
