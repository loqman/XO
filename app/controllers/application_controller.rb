class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_player

  def current_player
    unless session[:player_id].nil?
      @current_player ||= Player.find session[:player_id]
    else
      false
    end
  end

end
