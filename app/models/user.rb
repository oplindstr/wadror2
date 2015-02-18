class User < ActiveRecord::Base
  include RatingAverage, Enumerable

  has_secure_password

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3 }
  validates :username, length: { maximum: 15}
  validates :password, :format => {:with => /(?=.*[A-Z])/, message: "must contain a capital letter", multiline: true}
  validates :password, :format => {:with => /(?=.*\d+)/, message: "must contain a number", multiline: true}
  validates :password, :format => {:with => /^.{4,}$/, message: "must be at least 4 characters long", multiline: true}
  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, -> { uniq }, through: :memberships

  def to_s
    self.username
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by{ |r| r.score }.last.beer
  end

  def favorite_style
    return nil if ratings.empty?
    averages = ratings.joins(:beer).group(:style_id).average("score")
    max = averages.max_by { |x, y| y}
    style_id = max.first
    style = Style.find(style_id)
  end

  def favorite_brewery
    return nil if ratings.empty?
    averages = ratings.joins(:beer).group(:brewery_id).average("score")
    max = averages.max_by { |x, y| y}
    best_brewery_id = max.first
    brewery = Brewery.find(best_brewery_id)
  end

  def ratings_count
    return nil if ratings.empty?
    ratings.count
  end
end
