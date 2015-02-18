class Rating < ActiveRecord::Base
  belongs_to :beer, dependent: :destroy
  belongs_to :user, dependent: :destroy

  scope :recent, -> { order(created_at: :desc).limit(5) }

  validates :score, numericality: { greater_than_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true}

  def to_s
    "#{self.beer.name} #{self.score}"
  end

  def self.most_active_raters(n)
  	@ratings_by_user = Rating.group(:user_id).count
  	@sorted = @ratings_by_user.sort_by { |x,y| y }
  	@top_raters = @sorted.first(n)
  	@user_ids = []
  	@top_raters.each do |rater|
  		@user_ids.push(rater.first)
  	end
  	User.where(:id => @user_ids)
  end

  def self.best_beers(n)
    @averages_by_beer = Rating.group(:beer_id).average("score")
    @sorted = @averages_by_beer.sort_by { |x,y| y }
    @top = @sorted.first(n)
    @ids = []
    @top.each do |object|
      @ids.push(object.first)
    end
    Beer.where(:id => @ids)
  end

  def self.best_breweries(n)
    @averages_by_brewery = Rating.joins(:beer).group(:brewery_id).average("score")
    @sorted = @averages_by_brewery.sort_by { |x,y| y }
    @top = @sorted.first(n)
    @ids = []
    @top.each do |object|
      @ids.push(object.first)
    end
    Brewery.where(:id => @ids)
  end

  def self.best_styles(n)
    @averages_by_style = Rating.joins(:beer).group(:style_id).average("score")
    @sorted = @averages_by_style.sort_by { |x,y| y }
    @top = @sorted.first(n)
    @ids = []
    @top.each do |object|
      @ids.push(object.first)
    end
    Style.where(:id => @ids)
  end
end
