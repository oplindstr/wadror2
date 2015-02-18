require 'rails_helper'

describe 'Beers page' do

	let!(:brewery) { FactoryGirl.create :brewery }
    let!(:style) { FactoryGirl.create :style }
        let!(:user) { FactoryGirl.create :user }

        before :each do
          sign_in(username:"Pekka", password:"Foobar1")
        end

	it 'adds new beer if it is valid' do
		visit new_beer_path
        select('anonymous', from:'beer[brewery_id]')
        fill_in('beer[name]', with:'ebin')
        select('Weizen', from:'beer[style_id]')

        expect{
        	click_button('Create Beer')
        }.to change{Beer.count}.from(0).to(1)
	end
	
	it 'does not add an invalid beer' do
		visit new_beer_path
        select('anonymous', from:'beer[brewery_id]')
        fill_in('beer[name]', with:'')
        select('Weizen', from:'beer[style_id]')

        click_button('Create Beer')

        expect(Beer.count).to eq(0)
        expect(page).to have_content 'error prohibited'
        expect(page).to have_content 'New beer'
	end
end