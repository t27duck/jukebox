# frozen_string_literal: true

require "application_system_test_case"

class BackgroundsTest < ApplicationSystemTestCase
  setup do
    @background = backgrounds(:one)
  end

  test "visiting the index" do
    visit backgrounds_url
    assert_selector "h1", text: "Backgrounds"
  end

  test "should create background" do
    visit backgrounds_url
    click_on "New background"

    click_on "Create Background"

    assert_text "Background was successfully created"
    click_on "Back"
  end

  test "should update Background" do
    visit background_url(@background)
    click_on "Edit this background", match: :first

    click_on "Update Background"

    assert_text "Background was successfully updated"
    click_on "Back"
  end

  test "should destroy Background" do
    visit background_url(@background)
    accept_confirm { click_on "Destroy this background", match: :first }

    assert_text "Background was successfully destroyed"
  end
end
