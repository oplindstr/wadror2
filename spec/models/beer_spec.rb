require 'rails_helper'

RSpec.describe Beer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

describe Beer do
	let!(:style) { FactoryGirl.create :style }
	it "is saved having name and style" do
		beer = Beer.create name:"Beer", style:style

        expect(beer).to be_valid
		expect(Beer.count).to eq(1)
	end

	it "is not saved without a name" do
        beer = Beer.create style:style

        expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end

	it "is not saved without a style" do
        beer = Beer.create name:"Beer"

        expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end

end