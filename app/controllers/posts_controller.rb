class PostsController < ApplicationController
  allow_cors :index, :destroy

  def index
    render :json => ["post 1", "post 2", "post 3"]
  end

  def destroy
    render :json => { :status => "OK" }
  end
end
