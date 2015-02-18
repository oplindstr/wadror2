class AddStyleRefToBeers2 < ActiveRecord::Migration
  def change
  	add_reference :beers, :style, index: true
  end
end
