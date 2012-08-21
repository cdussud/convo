require 'spec_helper'

describe "Home page" do

  it "should have the content 'Sample App'" do
    visit root_path
    page.should have_content('Hello')
  end
end