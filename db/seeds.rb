# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

b1 = Brewery.create name:"Koff", year:1897
b2 = Brewery.create name:"Malmgard", year:2001
b3 = Brewery.create name:"Weihenstephaner", year:1042
style = Style.create name:"Lager", descr:"best"

b1.beers.create name:"Iso 3", style:style
b1.beers.create name:"Karhu", style:style
b1.beers.create name:"Tuplahumala", style:style
b2.beers.create name:"Huvila Pale Ale", style:style
b2.beers.create name:"X Porter", style:style
b3.beers.create name:"Hefezeizen", style:style
b3.beers.create name:"Helles", style:style

