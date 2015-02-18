require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
  	   allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
  	   	[ Place.new( name:"Oljenkorsi", id: 1 ) ]
  	   )

  	   visit places_path
  	   fill_in('city', with: 'kumpula')
  	   click_button "Search"

  	   expect(page).to have_content "Oljenkorsi"
  	
  end

  it "if none is returned by the API, show notice accordingly" do
  	   allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
  	   	[]
  	   )

  	   visit places_path
  	   fill_in('city', with: 'kumpula')
  	   click_button "Search"

  	   expect(page).to have_content "no locations in kumpula"
  	
  end
	
  it "if API returns many locations, show them all" do
  	   allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
  	   	[Place.new( name:"Oljenkorsi", id: 1 ), Place.new( name:"Bar", id: 2 )]
  	   )

  	   visit places_path
  	   fill_in('city', with: 'kumpula')
  	   click_button "Search"

  	   expect(page).to have_content "Oljenkorsi"
  	   expect(page).to have_content "Bar"
  	
  end
end