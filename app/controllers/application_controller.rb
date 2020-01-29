class ApplicationController < ActionController::Base

  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def may?(resource)
    current_user.author_of?(resource)
  end

  def no_rights(resource)
    redirect_to resource, alert: 'You have no rights to do this.'
  end
end

private

def gon_user
  gon.user = current_user.id if current_user
end
