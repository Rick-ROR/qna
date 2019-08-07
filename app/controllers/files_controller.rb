class FilesController < ApplicationController
  before_action :authenticate_user!

  expose(:file) { ActiveStorage::Attachment.find(params[:id]) }
  expose(:resource) { file.record }

  def destroy
    if current_user.author_of?(resource)
      file.purge
      if resource.is_a? Question
        @question = resource
        render template: 'questions/update.js.erb', :object => @question
      else
        render template: 'answers/update.js.erb', :locals => {answer: resource}
      end
    else
      redirect_to resource.is_a?(Question) ? resource : resource.question, notice: 'You have no rights to do this.'
    end
  end
end
