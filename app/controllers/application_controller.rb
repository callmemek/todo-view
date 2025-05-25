class ApplicationController < ActionController::Base
  # Making sure the browser is supported (custom method, maybe from a gem)
  allow_browser versions: :modern

  before_action :track_user_visits
  before_action :store_last_visit_time

  helper_method :get_time_based_greeting

  private

  # This method tracks how many times a user visits the site and each page
  def track_user_visits
    # Set up default visit data if not already stored
    session[:total_visits] ||= 0
    session[:total_visits] += 1

    current_page = request.path
    session[:page_visits] ||= {}
    session[:page_visits][current_page] ||= 0
    session[:page_visits][current_page] += 1

    # Make these values available in views
    @total_visits = session[:total_visits]
    @visits_to_current_page = session[:page_visits][current_page]
  end

  # This stores the time the user last visited any page
  def store_last_visit_time
    @last_visit_time = session[:last_visit_time]
    session[:last_visit_time] = Time.current
  end

  # Returns a greeting based on what time it is
  def get_time_based_greeting
    hour = Time.current.hour

    if hour >= 5 && hour <= 11
      "Good morning!"
    elsif hour >= 12 && hour <= 16
      "Good afternoon!"
    elsif hour >= 17 && hour <= 20
      "Good evening!"
    else
      "Good night!"
    end
  end
end
