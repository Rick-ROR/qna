class Api::V1::BaseController < ApplicationController
  skip_authorization_check
  before_action :doorkeeper_authorize!

  rescue_from CanCan::AccessDenied do |exception|
    render json: { errors: ["You are not authorized for this action."] }, status: :unprocessable_entity
  end

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  protected

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end
