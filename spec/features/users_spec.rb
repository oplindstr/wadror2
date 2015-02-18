require 'rails_helper'

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome Pekka!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'User Pekka does not exist!'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

end

describe "User's page" do
    let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
    let!(:style) { FactoryGirl.create :style}
    let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery, style:style }
    let!(:user2) { FactoryGirl.create :user2 }
    let!(:user) { FactoryGirl.create :user}
    let!(:rating) { FactoryGirl.create :rating, score:10, beer:beer1, user:user }
    let!(:rating2) { FactoryGirl.create :rating, score:20, beer:beer1, user:user2 }

    it "shows correct ratings" do
      visit user_path(user)
      expect(page).to have_content("iso 3 10")
      expect(page).not_to have_content("iso 3 20")
    end

    it "shows favorite style and brewery" do
      visit user_path(user)
      expect(page).to have_content("Favorite style:")
      expect(page).to have_content("Favorite brewery:")
    end
  end