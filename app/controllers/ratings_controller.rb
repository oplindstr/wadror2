class RatingsController < ApplicationController

  def index
    @ratings = Rating.all
    @recent = Rating.recent
    @most_active_raters = Rating.most_active_raters 3
    @best_beers = Rating.best_beers 3
    @best_breweries = Rating.best_breweries 3
    @best_styles = Rating.best_styles 3
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:'You should be signed in'
    end
    if @rating.save
      current_user.ratings << @rating
      redirect_to current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end