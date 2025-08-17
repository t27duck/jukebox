# frozen_string_literal: true

require "test_helper"

class BackgroundsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @background = backgrounds(:one)
  end

  test "should get index" do
    skip
    get backgrounds_url
    assert_response :success
  end

  test "should get new" do
    skip
    get new_background_url
    assert_response :success
  end

  test "should create background" do
    skip
    assert_difference("Background.count") do
      post backgrounds_url, params: { background: {} }
    end

    assert_redirected_to background_url(Background.last)
  end

  test "should show background" do
    skip
    get background_url(@background)
    assert_response :success
  end

  test "should get edit" do
    skip
    get edit_background_url(@background)
    assert_response :success
  end

  test "should update background" do
    skip
    patch background_url(@background), params: { background: {} }
    assert_redirected_to background_url(@background)
  end

  test "should destroy background" do
    skip
    assert_difference("Background.count", -1) do
      delete background_url(@background)
    end

    assert_redirected_to backgrounds_url
  end
end
