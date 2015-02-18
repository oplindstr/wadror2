class Beer < ActiveRecord::Base
  include RatingAverage
  include Enumerable
  belongs_to :brewery
  belongs_to :style
  validates :name, presence: true
  validates :style_id, presence: true
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  def to_s
    "#{self.name}, #{self.brewery.name}"
  end
end
