class ApplicationController < ActionController::API
  before_action :set_current_user

  private

  def set_current_user
    @current_user = User.find_by(id: request.headers["USER_ID"])

    unless @current_user
      render json: { error: "User not found" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def render_forbidden
    render json: { error: "Forbidden" }, status: :forbidden
  end
end


