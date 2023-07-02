require 'test_helper'

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  test "should redirect create if current user is staff" do
    staff_user = users(:staff_user) # Utilizatorul staff definit în fixtures/users.yml

    post reviews_url, params: { review: { title: "Test Review", message: "This is a test review." } }, headers: { 'Authorization': "Bearer #{staff_user.generate_jwt}" }

    assert_redirected_to root_path
    assert_equal "Forbbiden!", flash[:alert]
  end

  test "should create review and redirect back with notice" do
    user = users(:regular_user) # Utilizatorul normal definit în fixtures/users.yml

    post reviews_url, params: { review: { title: "Test Review", message: "This is a test review.", user_id: user.id, product_id: products(:product1).id } }, headers: { 'Authorization': "Bearer #{user.generate_jwt}" }

    assert_redirected_to root_path
    assert_equal "Review added successfully!", flash[:notice]
  end

  test "should handle invalid review and redirect back with error message" do
    user = users(:regular_user) # Utilizatorul normal definit în fixtures/users.yml

    post reviews_url, params: { review: { title: "", message: "", user_id: user.id, product_id: products(:product1).id } }, headers: { 'Authorization': "Bearer #{user.generate_jwt}" }

    assert_redirected_to root_path
    assert_match /Title can't be blank/, flash[:alert]
    assert_match /Message can't be blank/, flash[:alert]
  end
end
