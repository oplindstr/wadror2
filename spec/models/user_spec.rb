require 'rails_helper'
BeerClub
BeerClubsController
MembershipsController
Membership
RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

describe User do
	it "has the username set correctly" do
		user = User.new username:"Pekka"

		expect(user.username).to eq("Pekka")
	end

	it "is not saved without a password" do
		user = User.create username:"Pekka"

		expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end

	it "is not saved with an invalid password" do
		user = User.create username:"Pekka", password:"Se1", password_confirmation:"Se1"

        expect(user).not_to be_valid
		expect(User.count).to eq(0)

		user = User.create username:"Pekka", password:"AbCdEfG", password_confirmation:"AbCdEfG"
		expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end

    describe "favorite beer" do
    	let(:user){FactoryGirl.create(:user)}

	    it "has method for determining one" do
			expect(user).to respond_to(:favorite_beer)
		end

		it "and without ratings does not have one" do
			expect(user.favorite_beer).to eq(nil)
		end

	    it "is the only rated if only one rating" do

	    	beer = create_beer_with_rating(10, user)
	    	expect(user.favorite_beer).to eq(beer)
	    end

	    it "is the one with highest rating if several rated" do

	    	create_beers_with_ratings(10,20,11,24,3,user)
	    	best = create_beer_with_rating(25, user)

	    	expect(user.favorite_beer).to eq(best)
	    end
	end

    def create_beer_with_rating(score, user)
    	beer = FactoryGirl.create(:beer)
    	FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    	beer
    end

    def create_beers_with_ratings(*scores, user)
    	scores.each do |score|
    		create_beer_with_rating(score, user)
    	end
    end

    describe "favorite style" do
    	let(:user){ FactoryGirl.create(:user) }
        let!(:style2) {FactoryGirl.create(:style2) }
        let!(:brewery) { FactoryGirl.create(:brewery)}

    	it "has favorite style if ratings exist" do
    		beer = create_beer_with_rating(10, user)

    		expect(user.favorite_style).to eq(beer.style.name)
    	end

    	it "and gives correct favorite style with multiple ratings" do
    		beer = FactoryGirl.create(:beer)
    		beer2 = FactoryGirl.create(:beer2)
    		beer3 = FactoryGirl.create(:beer3, name:"lol", brewery:brewery, style:style2)

    		rating = FactoryGirl.create(:rating, score:20, beer:beer3, user:user)
    		rating2 = FactoryGirl.create(:rating, score:31, beer:beer, user:user)
    		rating3 = FactoryGirl.create(:rating, score:10, beer:beer2, user:user)

    		expect(user.favorite_style).to eq(beer.style.name)
    	end


    end

    describe "favorite brewery" do
    	let(:user){ FactoryGirl.create(:user) }

    	it "has favorite brewery if ratings exist" do
    		beer = create_beer_with_rating(10, user)

    		expect(user.favorite_brewery).to eq(beer.brewery.name)
    	end

    	it "and gives correct favorite brewery with multiple ratings" do
    		brewery = FactoryGirl.create(:brewery)
            style = FactoryGirl.create(:style)
    		beer = FactoryGirl.create(:beer, name:"lol2", brewery:brewery, style:style)
    		beer2 = FactoryGirl.create(:beer, name:"lol3", brewery:brewery, style:style)
    		beer3 = FactoryGirl.create(:beer, name:"lol4", brewery:brewery, style:style)
    		brewery2 = FactoryGirl.create(:brewery2)
    		beer4 = FactoryGirl.create(:beer, name:"lol", brewery:brewery2, style:style)

    		rating = FactoryGirl.create(:rating, score:20, beer:beer, user:user)
    		rating2 = FactoryGirl.create(:rating, score:31, beer:beer2, user:user)
    		rating3 = FactoryGirl.create(:rating, score:10, beer:beer3, user:user)
    		rating4 = FactoryGirl.create(:rating, score:22, beer:beer4, user:user)

    		expect(user.favorite_brewery).to eq(beer4.brewery.name)
    	end
    end


    describe "with a proper password" do
        let(:user){ FactoryGirl.create(:user) }

    	it "is saved" do
			expect(user).to be_valid
			expect(User.count).to eq(1)
	    end

		it "and with two ratings, has the correct average rating" do
	        user.ratings << FactoryGirl.create(:rating)
	        user.ratings << FactoryGirl.create(:rating2)

	        expect(user.ratings.count).to eq(2)
	        expect(user.average_rating).to eq(15.0)
		end
	end
end
