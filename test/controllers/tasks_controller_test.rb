require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    # Create a test user
    @user = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    
    # Manual sign in via POST request
    post user_session_path, params: { 
      user: { 
        email: "test@example.com", 
        password: "password123" 
      } 
    }
  end

  test "should get index" do
    get tasks_url
    assert_response :success
  end

  test "should get show" do
    # Create a test task associated with the user
    task = Task.create!(title: "Test Task", description: "Test description", user: @user)
    get task_url(task)
    assert_response :success
  end

  test "should get new" do
    get new_task_url
    assert_response :success
  end

  test "should get edit" do
    # Create a test task associated with the user
    task = Task.create!(title: "Test Task", description: "Test description", user: @user)
    get edit_task_url(task)
    assert_response :success
  end
end