class AddStyleRefToBeers < ActiveRecord::Migration
  def change
  	add_reference :beers, :styles, index: true
  end
end
