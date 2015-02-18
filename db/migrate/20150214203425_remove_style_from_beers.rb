class RemoveStyleFromBeers < ActiveRecord::Migration
  def change
  	change_table :beers do |t|
  		t.remove :style
  	end
  end
end
