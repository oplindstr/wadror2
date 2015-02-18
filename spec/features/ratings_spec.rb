require 'rails_helper'

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:style) { FactoryGirl.create :style }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery, style:style }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery, style:style }
  let!(:user) { FactoryGirl.create :user }
    let!(:rating) { FactoryGirl.create :rating, score:10, beer:beer1, user:user }
  let!(:rating2) { FactoryGirl.create :rating, score:20, beer:beer2, user:user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(2).to(3)

    expect(user.ratings.count).to eq(3)
    expect(beer1.ratings.count).to eq(2)
    expect(beer1.average_rating).to eq(12)
  end

  it "are shown correctly on the ratings page" do
    visit ratings_path
    expect(page).to have_content 'Number of ratings'
    expect(page).to have_content 'iso 3 10 Pekka'
  end

  it "is deleted when user deletes it from user page" do
    visit user_path(user)
    expect(page).to have_content("iso 3 10")

    expect{
      page.find("li", :text => "iso 3 10").click_link("delete")
    }.to change{Rating.count}.from(2).to(1)

    expect(page).not_to have_content("iso 3 10")
  end

end