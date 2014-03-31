class StaticPagesController < ApplicationController
  Dir["helper/*.rb"].each {|file| require file }
  def home
  end
  def calculate
    @battle = params[:fleet]
    @return = JSON.parse @battle
    render json: @return
  end
end
