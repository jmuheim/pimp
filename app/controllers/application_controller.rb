require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :init_guest_user, unless: -> { user_signed_in? }
  attr_reader :guest_user

  before_action :set_locale

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    {locale: I18n.locale}
  end

  # Guest accounts: in order to fix the problem with ajax requests you have to turn off protect_from_forgery for the
  # controller action with the ajax request.
  # See https://github.com/plataformatec/devise/wiki/How-To:-Create-a-guest-user)
  # skip_before_action :verify_authenticity_token, only: [:name_of_your_action]

  protected

  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def configure_permitted_parameters
    devise_parameter_sanitizer.for :sign_up do |u|
      u.permit :name, :email, :password, :password_confirmation, :remember_me
    end

    devise_parameter_sanitizer.for :sign_in do |u|
      u.permit :name, :email, :password, :remember_me
    end

    devise_parameter_sanitizer.for :account_update do |u|
      u.permit :name, :email, :password, :password_confirmation, :current_password
    end
  end

  private

  def user_signed_in?
    current_user.present? ? !current_user.guest? : super
  end

  def init_guest_user
    @current_user = User.guests.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound
    remove_guest_user
    init_guest_user
  end

  def create_guest_user
    user = User.create do |user|
      user.guest = true
      user.skip_confirmation!
    end

    session[:guest_user_id] = user.id
    user
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def remove_guest_user
    User.find(session[:guest_user_id]).delete rescue ActiveRecord::RecordNotFound
  ensure
    session[:guest_user_id] = nil
  end
end
