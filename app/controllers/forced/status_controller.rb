module Forced
  class StatusController < ApplicationController
    def index
      response = Forced::Response.call(request)

      render json: response
    end
  end
end