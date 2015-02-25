class BeerClub < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :users, -> { uniq }, through: :memberships

  has_many :confirmed, -> { where confirmed:true }, class_name: "Membership"
  has_many :unconfirmed, -> { where confirmed:[nil,false] }, class_name: "Membership"

  has_many :confirmed_users, class_name: "User", through: :confirmed, source: :user
  has_many :unconfirmed_users, class_name: "User", through: :unconfirmed, source: :user

  def to_s
    "#{self.name} #{self.city}"
  end
end
