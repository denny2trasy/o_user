class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def referer_url_with_msg(msg)
    URI.parse(request.env['HTTP_REFERER']).add_query(:msg => msg).to_s
  end
end
