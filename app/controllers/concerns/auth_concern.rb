# frozen_string_literal: true

module AuthConcern
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_admin!
    return if current_user&.admin?

    redirect_to request.referer || root_path, alert: t('notice.only_admin')
  end

  def user_not_authorized
    redirect_to request.referer || root_path, alert: t('notice.only_user')
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session.delete(:user_id)
    session.clear
  end

  def signed_in?
    current_user.present?
  end

  def authenticate_user!
    return if signed_in?

    redirect_to request.referer || root_path, alert: t('notice.only_user')
  end
end
