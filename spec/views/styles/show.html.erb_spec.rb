require 'rails_helper'

RSpec.describe "styles/show", type: :view do
  before(:each) do
    @style = assign(:style, Style.create!(
      :name => "Name",
      :descr => "MyText"
    ))
  end
end
