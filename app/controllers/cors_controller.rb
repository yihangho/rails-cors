class CorsController < ApplicationController
  protect_from_forgery :with => :null_session

  def preflight
    begin
      http_request_verb = request.headers['Access-Control-Request-Method']
      raise unless ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE"].include? http_request_verb

      # This line will raise an exception if the path does not resolve to any controller/action.
      details = Rails.application.routes.recognize_path(request.original_fullpath, :method => http_request_verb.downcase.to_sym)

      controller_class_name = details[:controller].capitalize + "Controller"
      action_name = details[:action].to_sym

      # If this statement returns true, then CORS is allowed
      if eval(controller_class_name).cors_allowed_actions.include?(action_name)
        headers['Access-Control-Allow-Origin']  = request.headers['Origin']
        headers['Access-Control-Allow-Methods'] = http_request_verb
        headers['Access-Control-Max-Age']       = "1728000"
        headers['Access-Control-Allow-Headers'] = request.headers['Access-Control-Request-Headers']
      end
    rescue
    end

    render :text => "", :content_type => 'text/plain'
  end
end
