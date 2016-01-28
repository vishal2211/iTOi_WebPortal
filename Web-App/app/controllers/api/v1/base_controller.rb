class Api::V1::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token
  #before_filter :validate_authorization

  protected

  def validate_authorization
    unless request.headers['X-API-Authentication'] == '394f026f0d288eb28d75a03e137730c5'
      render :text => "Unauthorized", :status => 401
      return false
    end
    return true
  end

end
