class SearchController < ApplicationController
  skip_authorization_check

  def result
    @results = Services::SearchSphinx.call(search_params)
  end

  def search_params
    params.permit(:query, :scope).to_h.symbolize_keys
  end
end
