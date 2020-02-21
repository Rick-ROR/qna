class SearchController < ApplicationController
  skip_authorization_check

  def result
    @results = Services::SearchSphinx.new.call(search_params)
  end

  def search_params
    params.permit(:query, :scope)
  end
end
