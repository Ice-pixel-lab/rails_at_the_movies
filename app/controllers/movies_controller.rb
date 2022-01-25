class MoviesController < ApplicationController
  def index
    # @movies = Movie.order("average_vote DESC") # ORDER BY average_vote DESC --> SQL

    @movies = Movie.includes(:production_company).all.order("average_vote DESC")
  end

  def show
    @movie = Movie.find(params[:id])
  end
end
