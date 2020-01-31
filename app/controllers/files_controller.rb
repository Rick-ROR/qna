class FilesController < ApplicationController
  include FilesHelper
  before_action :authenticate_user!

  expose(:file) { ActiveStorage::Attachment.find(params[:id]) }
  expose(:resource) { file.record }

  def destroy
    authorize! :destroy, resource
    file.purge
    if is_question?(resource)
      @question = resource
      render template: 'questions/update.js.erb', :object => @question
    else
      render template: 'answers/update.js.erb', :locals => {answer: resource}
    end
  end
end
