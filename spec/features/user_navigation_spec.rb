require 'rails_helper'

RSpec.feature "User Navigation", type: :feature do
  scenario "User visits homepage" do
    visit root_path
    expect(page).to have_current_path(root_path)
    expect(page).to have_css("h1", text: "Klaviyo Tag Manager")
  end

  scenario "User selects profiles using checkboxes" do
    visit root_path

    # Check that checkboxes are present and if no proiles have sync at least the header checkbox exist.
    expect(page).to have_css('input[type="checkbox"]', minimum: 1)

    # Select first checkbox
    first('input[type="checkbox"]').check
    expect(first('input[type="checkbox"]')).to be_checked
  end

  scenario "User adds tags to selected profiles successfully" do
    # Mock the API call for adding tags
    # stub_request(:post, /.*klaviyo.*profiles.*tags.*/)
    #   .to_return(status: 200, body: { success: true }.to_json)

    visit root_path

    # Select one or more profiles
    first('input[type="checkbox"]').check
    all('input[type="checkbox"]').last.check

    # Click Add Tags button
    click_button "Add Tags"

    # Modal should open
    expect(page).to have_css('.modal', visible: true)

    # Select a tag from dropdown
    select "medium", from: "engagement_status"

    # Submit the modal
    within('.modal') do
      click_button "OK"
    end

    # Check that modal is closed:
    expect(page).to have_css('.modal', visible: false)
  end


  scenario "User can cancel tag addition in modal" do
    visit root_path

    # Select a profile
    first('input[type="checkbox"]').check

    # Open modal
    click_button "Add Tags"
    expect(page).to have_css('.modal', visible: true)

    # Cancel/close modal
    within('.modal') do
      click_button "Cancel"
    end

    # Modal should close
    expect(page).to have_css('.modal', visible: false)
  end
end
