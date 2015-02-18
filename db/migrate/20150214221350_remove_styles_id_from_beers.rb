class RemoveStylesIdFromBeers < ActiveRecord::Migration
  def change
  	remove_reference :beers, :styles
  end
end
