class ApplicationController < ActionController::Base

  before_action :store_user_location!, if: :storable_location?
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, alert: exception.message }
      format.json { render json: { error: exception.message } }
      format.js { head :forbidden }
    end
  end


  def may?(resource)
    current_user.author_of?(resource)
  end

  def no_rights(resource)
    redirect_to resource, alert: 'You have no rights to do this.'
  end

  check_authorization unless: :devise_controller?


  private

  def gon_user
    gon.user = current_user.id if current_user
  end

  def storable_location?
    request.get? && is_navigational_format? &&
      !request.xhr? && !request.path.start_with?("/users/")
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer || root_path
  end
end
