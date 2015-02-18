class Brewery < ActiveRecord::Base
  include Enumerable, RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  validates :name, presence: true
  validates :year, numericality: {greater_than_or_equal_to: 1042}
  validate :year_cannot_be_in_the_future

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2015
    puts "changed year to #{year}"
  end

  def to_s
    self.name
  end

  def year_cannot_be_in_the_future
    if self.year > Time.now.year
      errors.add(:year, " cannot be in the future")
    end
  end
end
