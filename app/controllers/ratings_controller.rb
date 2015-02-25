class RatingsController < ApplicationController

  def index
    updated = Rails.cache.read('ratings_cache_updated')
    if updated.nil? or updated < Time.now - 10.minutes
      cache_update
    end

    @ratings = Rails.cache.read('ratings')
    @recent = Rails.cache.read('ratings_recent')
    @most_active_raters = Rails.cache.read('most_active_raters')
    @best_beers = Rails.cache.read('best_beers')
    @best_breweries = Rails.cache.read('best_breweries')
    @best_styles = Rails.cache.read('best_styles')

    #tulee virhe näkymän favorite_style/brewery-kohdissa jos ei lataa näitä
    @styles = Style.all
    @breweries = Brewery.all
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

  private

  def cache_update
    Rails.cache.write('ratings_cache_updated', Time.now)
    @ratings = Rating.all
    @recent = Rating.recent
    @most_active_raters = Rating.most_active_raters(3)
    @best_beers = Rating.best_beers(3)
    @best_breweries = Rating.best_breweries(3)
    @best_styles = Rating.best_styles(3)

    Rails.cache.write('ratings', @ratings)
    Rails.cache.write('ratings_recent', @recent)
    Rails.cache.write('most_active_raters', @most_active_raters)
    Rails.cache.write('best_beers', @best_beers)
    Rails.cache.write('best_styles', @best_styles)
    Rails.cache.write('best_breweries', @best_breweries)
  end
end