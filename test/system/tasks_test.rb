require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  setup do
    @task = tasks(:one) # Assumes a fixture with a task
  end

  test "visiting the index" do
    visit tasks_url
    assert_selector "h1", text: "Tasks"
    assert_selector "table"
    assert_text @task.title
  end

  test "should create task with valid file" do
    visit new_task_url
    fill_in "Title", with: "Unique Task"
    fill_in "Description", with: "This is a test task"
    check "Completed"
    attach_file "File", Rails.root.join("test/fixtures/files/sample.png")
    click_on "Create Task"

    assert_text "Task was successfully created"
    assert_text "Unique Task"
    assert_text "Completed"
    assert_text "sample.png"
  end

  test "should not create task with duplicate title" do
    visit new_task_url
    fill_in "Title", with: @task.title
    fill_in "Description", with: "Duplicate title test"
    click_on "Create Task"

    assert_text "Title has already been taken"
  end

  test "should not create task without title" do
    visit new_task_url
    fill_in "Description", with: "No title test"
    click_on "Create Task"

    assert_text "Title can't be blank"
  end

  test "should not create task with invalid file format" do
    visit new_task_url
    fill_in "Title", with: "Invalid File Task"
    attach_file "File", Rails.root.join("test/fixtures/files/invalid.mp3")
    click_on "Create Task"

    assert_text "File must be a PNG, JPEG, WEBP, PDF, TXT, or ZIP file"
  end

  test "should not create task with file larger than 25MB" do
    visit new_task_url
    fill_in "Title", with: "Large File Task"
    attach_file "File", Rails.root.join("test/fixtures/files/large_file.zip")
    click_on "Create Task"

    assert_text "File size must be less than 25MB"
  end

  test "should update task" do
    visit edit_task_path(@task)
    fill_in "Title", with: "Updated Task"
    fill_in "Description", with: "Updated description"
    uncheck "Completed"
    attach_file "File", Rails.root.join("test/fixtures/files/sample.pdf")
    click_on "Update Task"

    assert_text "Task was successfully updated"
    assert_text "Updated Task"
    assert_text "Updated description"
    assert_text "Not Completed"
    assert_text "sample.pdf"
  end

  test "should remove file on update" do
    @task.file.attach(io: File.open(Rails.root.join("test/fixtures/files/sample.png")), filename: "sample.png", content_type: "image/png")
    @task.save!
    visit edit_task_path(@task)
    check "Remove current file"
    click_on "Update Task"

    assert_text "Task was successfully updated"
    assert_no_text "sample.png"
  end

  test "should destroy task with confirmation" do
    visit tasks_url
    assert_text "Test Task 1" # Ensure the task exists before deletion
    page.accept_confirm do
      click_link "Delete", href: task_path(@task)
    end
    assert_text "Task was successfully deleted"
    assert_no_text "Test Task 1"
  end
end