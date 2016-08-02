class WelcomeController < ApplicationController
  def index
  end

  def update
    auth = FbGraph2::Auth.new(ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'])
    signed_request = auth.from_cookie cookies
    auth.fb_exchange_token = signed_request.access_token
    @access_token = auth.access_token!
  end
end
