# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# System Testing with Ruby on Rails
## Workshop Presentation Slides

---

## Slide 1: Welcome to System Testing with Rails
**Subtitle:** Building Confidence Through Comprehensive Testing

**Contents:**
- **Workshop Overview**: System Testing fundamentals with Rails
- **What We'll Cover**: Authentication, CRUD operations, file uploads
- **Demo Application**: Task Manager with User Authentication
- **Learning Outcomes**: Write reliable system tests, debug testing issues, implement best practices
- **Prerequisites**: Basic Rails knowledge, understanding of MVC pattern

---

## Slide 2: What is System Testing?
**Subtitle:** Testing Your Application Like Real Users Do

**Contents:**
- **Definition**: End-to-end testing that simulates real user interactions
- **Key Characteristics**:
  - Tests the complete application stack
  - Uses real browsers (Chrome, Firefox)
  - Simulates user actions: clicking, typing, navigation
  - Validates entire user workflows
- **System Tests vs Unit Tests**:
  - Unit: Individual methods/classes
  - System: Complete user journeys
- **When to Use**: Critical user paths, authentication flows, complex interactions

---

## Slide 3: Rails System Testing Stack
**Subtitle:** Tools and Technologies

**Contents:**
- **Core Components**:
  - **Capybara**: Web application testing framework
  - **Selenium WebDriver**: Browser automation
  - **Minitest**: Rails default testing framework
  - **Headless Chrome**: Fast, reliable browser testing
- **Configuration**:
  ```ruby
  class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end
  ```
- **Why This Stack**: Reliable, fast, well-integrated with Rails

---

## Slide 4: Demo App Architecture
**Subtitle:** Task Manager with Authentication

**Contents:**
- **Technology Stack**:
  - Rails 8.0 with Devise authentication
  - SQLite database with Active Storage
  - Bootstrap 5 for UI
- **Key Features to Test**:
  - User registration and login
  - CRUD operations for tasks
  - File attachment system (PNG, JPEG, WEBP, PDF, TXT, ZIP)
  - User data isolation
- **Security Model**: Each user sees only their own tasks
- **File Support**: Images, PDFs, text files with validation (max 25MB)

---

## Slide 5: Setting Up System Tests
**Subtitle:** Configuration and Test Structure

**Contents:**
- **Test File Location**: `test/system/`
- **Base Class Setup**:
  ```ruby
  class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end
  ```
- **Test Class Structure**:
  ```ruby
  class TasksTest < ApplicationSystemTestCase
    setup do
      @user = users(:test_user)
      login_as(@user)
    end
  end
  ```
- **Fixtures**: Test data setup in `test/fixtures/`

---

## Slide 6: Testing Authentication Flows
**Subtitle:** Ensuring Secure Access Control

**Contents:**
- **Login Helper Method**:
  ```ruby
  def login_as(user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_on "Log in"
    assert_text "Signed in successfully"
  end
  ```
- **Test Scenarios**:
  - Successful login with valid credentials
  - Failed login with invalid credentials
  - Logout functionality
  - Protected route redirection
- **Security Validation**: Unauthorized access prevention

---

## Slide 7: Testing CRUD Operations
**Subtitle:** Validating Core Application Functionality

**Contents:**
- **Create Operations**:
  ```ruby
  test "should create task with valid data" do
    visit new_task_url
    fill_in "Title", with: "New Task"
    fill_in "Description", with: "Task description"
    click_on "Create Task"
    assert_text "Task was successfully created"
  end
  ```
- **Read Operations**: Verify data display and user-specific filtering
- **Update Operations**: Edit forms and data persistence
- **Delete Operations**: Confirmation dialogs and data removal
- **Validation Testing**: Error handling for invalid input

---

## Slide 8: Testing File Attachments
**Subtitle:** Complex Feature Testing

**Contents:**
- **File Upload Testing**:
  ```ruby
  test "should create task with valid file" do
    visit new_task_url
    fill_in "Title", with: "Task with File"
    attach_file "File", Rails.root.join("test/fixtures/files/sample.png")
    click_on "Create Task"
    assert_text "Task was successfully created"
    assert_text "sample.png"
  end
  ```
- **Test Scenarios**:
  - Valid file upload (PNG, JPEG, WEBP, PDF, TXT, ZIP)
  - Invalid file type rejection (e.g., MP3)
  - File size limit validation (<25MB)
  - File removal functionality
- **Test File Setup**: Store sample files in `test/fixtures/files/`

---

## Slide 9: Common Testing Patterns
**Subtitle:** Reusable Testing Strategies

**Contents:**
- **Page Navigation**:
  ```ruby
  visit tasks_url
  click_link "New Task"
  assert_current_path new_task_path
  ```
- **Form Interactions**:
  ```ruby
  fill_in "Title", with: "Test Task"
  select "High", from: "Priority"
  check "Completed"
  ```
- **Assertions**:
  ```ruby
  assert_text "Expected text"
  assert_no_text "Should not appear"
  assert_current_path expected_path
  ```
- **Waiting for Dynamic Content**: `assert_text` automatically waits

---

## Slide 10: Debugging System Tests
**Subtitle:** Troubleshooting Common Issues

**Contents:**
- **Common Problems**:
  - Element not found errors
  - Timing issues with JavaScript
  - Browser driver compatibility (e.g., chromedriver permissions)
  - Test data conflicts
- **Debugging Techniques**:
  ```ruby
  save_and_open_screenshot  # Visual debugging
  save_and_open_page       # HTML source inspection
  puts page.html           # Console output
  ```
- **Real Example**: Fixed `NoMethodError: undefined method 'submit'`
  - **Problem**: Used unsupported `page.driver.submit` for logout
  - **Solution**: Replaced with `click_link "Logout"` to simulate DELETE request

---

## Slide 11: Test Organization and Best Practices
**Subtitle:** Writing Maintainable Tests

**Contents:**
- **Test Structure**:
  - One test class per feature/controller
  - Descriptive test names
  - Logical test grouping
- **Setup and Teardown**:
  ```ruby
  setup do
    @user = users(:test_user)
    login_as(@user)
  end
  ```
- **Helper Methods**: Reusable actions like login, form filling
- **Test Data**: Use fixtures or factories consistently
- **Assertions**: Test one behavior per test method

---

## Slide 12: Performance and Reliability
**Subtitle:** Fast and Stable Tests

**Contents:**
- **Speed Optimization**:
  - Use headless browsers
  - Minimize database operations
  - Parallel test execution where possible
- **Reliability Strategies**:
  - Explicit waits instead of sleep
  - Unique test data to avoid conflicts
  - Clean database state between tests
- **CI/CD Integration**:
  ```bash
  rails test:system
  # 10 runs, 32 assertions, 0 failures, 0 errors
  ```

---

## Slide 13: Live Demo - Task Manager Testing
**Subtitle:** System Tests in Action with Real Application

**Contents:**

### Part 1: Current App Features Demo
- **Authentication System**:
  - User registration/login
  - Protected routes (redirect to login if not authenticated)
  - Session management with "Remember me"
  - Secure logout functionality
- **Task Management Features**:
  - Create tasks with title, description
  - File attachments (images, PDFs, documents)
  - Edit existing tasks
  - Mark tasks as complete/incomplete
  - Delete tasks with confirmation
  - User-specific task isolation

---

## Slide 13.1: Live Demo - Task Manager Testing
**Subtitle:** System Tests in Action with Real Application

**Contents:**
### Part 2: Running Existing Test Suite
```bash
# Run all system tests
rails test:system

# Expected output:
# Running 10 tests in a single process
# ✅ Authentication tests (4 tests)
# ✅ CRUD operations tests (4 tests) 
# ✅ File upload tests (2 tests)
# 10 runs, 32 assertions, 0 failures, 0 errors, 0 skips
```

---

## Slide 13.2: Live Demo - Task Manager Testing
**Subtitle:** System Tests in Action with Real Application

**Contents:**
### Part 3: Existing Test Cases Demonstration
**Showing Our Current 10 Test Cases:**

**Authentication Tests (4 tests):**
```ruby
# test/system/tasks_test.rb
test "should redirect to login when not authenticated" do
  logout
  visit tasks_url
  assert_current_path new_user_session_path
  assert_text "Log in"
end

test "should login with valid credentials" do
  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: "password123"
  click_on "Log in"
  assert_text "Signed in successfully"
  assert_current_path tasks_url
end

test "should logout successfully" do
  visit tasks_url
  click_link "Logout"
  assert_text "Signed out successfully"
  assert_current_path new_user_session_path
end

test "should display user email on dashboard" do
  visit tasks_url
  assert_text "Welcome, #{@user.email}"
end
```

---

## Slide 13.3: Live Demo - Task Manager Testing
**Subtitle:** System Tests in Action with Real Application

**Contents:**
**CRUD Operations Tests (4 tests):**
```ruby
# test/system/tasks_test.rb
test "should create task with valid data" do
  visit new_task_url
  fill_in "Title", with: "New Task"
  fill_in "Description", with: "Task description"
  click_on "Create Task"
  assert_text "Task was successfully created"
  assert_text "New Task"
end

test "should update existing task" do
  visit edit_task_path(@task)
  fill_in "Title", with: "Updated Task Title"
  click_on "Update Task"
  assert_text "Task was successfully updated"
  assert_text "Updated Task Title"
end

test "should delete task with confirmation" do
  visit tasks_url
  assert_text "Test Task 1"
  page.accept_confirm do
    click_link "Delete", href: task_path(@task)
  end
  assert_text "Task was successfully deleted"
  assert_no_text "Test Task 1"
end

test "should not create task with duplicate title" do
  visit new_task_url
  fill_in "Title", with: @task.title
  fill_in "Description", with: "Duplicate title test"
  click_on "Create Task"
  assert_text "Title has already been taken for this user"
end
```

---

## Slide 13.4: Live Demo - Task Manager Testing
**Subtitle:** System Tests in Action with Real Application

**Contents:**
**File Upload Tests (2 tests):**
```ruby
# test/system/tasks_test.rb
test "should create task with valid file attachment" do
  visit new_task_url
  fill_in "Title", with: "Task with File"
  attach_file "File", Rails.root.join("test/fixtures/files/sample.png")
  click_on "Create Task"
  assert_text "Task was successfully created"
  assert_text "sample.png"
end

test "should reject invalid file format" do
  visit new_task_url
  fill_in "Title", with: "Invalid File Task"
  attach_file "File", Rails.root.join("test/fixtures/files/invalid.mp3")
  click_on "Create Task"
  assert_text "File must be a PNG, JPEG, WEBP, PDF, TXT, or ZIP file"
end
```

---

## Slide 13.5: Live Demo - Task Manager Testing
**Subtitle:** System Tests in Action with Real Application

**Contents:**
### Part 4: Breaking the Application (Intentionally)
**Simulate Real Bug**: Remove CSRF token from task completion form

```erb
<!-- app/views/tasks/index.html.erb - BREAK THIS -->
<%= form_with model: task, local: true do |form| %>
  <%= form.hidden_field :authenticity_token %>
  <%= form.check_box :completed, { 
    onchange: "this.form.submit()" 
  } %>
<% end %>
```

**Expected Test Failure**:
```bash
rails test:system test/system/tasks_test.rb

# FAILURE:
# ActionController::InvalidAuthenticityToken: 
# Can't verify CSRF token authenticity
```

---

## Slide 13.6: Live Demo - Task Manager Testing
**Subtitle:** System Tests in Action with Real Application

**Contents:**
### Part 5: Watch Browser Automation
**Live Browser Actions We'll See**:
1. Chrome browser opens automatically
2. Navigates to login page
3. Fills in email and password fields
4. Clicks "Log in" button
5. Navigates to tasks index
6. Locates specific task element
7. Clicks checkbox
8. Verifies text changes
9. Browser closes after test

---

## Slide 14: Key Takeaways
**Subtitle:** What You've Learned Today

**Contents:**
- **System Testing Delivers**:
  - ✅ End-to-end confidence in user workflows
  - ✅ Early detection of integration issues
  - ✅ Automated validation of critical features
- **Rails Makes It Easy**:
  - Built-in Capybara and Selenium integration
  - Simple test configuration and setup
  - Excellent debugging tools and helpers
- **Best Practices Applied**:
  - Test complete user journeys
  - Focus on critical application paths
  - Write maintainable, readable tests

---

## Slide 15: Quick Resources & Next Steps
**Subtitle:** Continue Your Testing Journey

**Contents:**
- **Essential Reading**:
  - Rails Testing Guide: [guides.rubyonrails.org](https://guides.rubyonrails.org)
  - Capybara Documentation: [github.com/teamcapybara/capybara](https://github.com/teamcapybara/capybara)
- **Immediate Actions**:
  - Add system tests to your current Rails apps
  - Start with authentication and core CRUD flows
  - Practice debugging failing tests
- **Advanced Learning**:
  - JavaScript-heavy application testing
  - Page Object patterns for complex UIs
  - CI/CD integration strategies

---

## Slide 16: Thank You & Q&A
**Subtitle:** Questions and Wrap-Up

**Contents:**
- **Workshop Complete!** You now have practical system testing skills
- **Key Achievement**: You've seen a complete Rails app with 100% passing system tests
- **Questions Welcome**:
  - Implementation strategies for your projects
  - Debugging specific testing issues
  - Tool recommendations and alternatives
- **Contact**: [Your contact information]
- **Repository**: Workshop materials and code examples available
- **Next Steps**: Apply these techniques to build more reliable Rails applications
