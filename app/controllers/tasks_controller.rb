# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  before_action :authenticate_user! # Add this line to ensure user is authenticated
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = current_user.tasks # Only current user's tasks will be shown
  end

  def show
  end

  def new
    @task = current_user.tasks.new # Associated with current user
  end

  def edit
  end

  def create
    @task = current_user.tasks.new(task_params) # current user এর সাথে associate করুন
    if @task.save
      redirect_to @task, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if params[:task][:remove_file] == "1" && @task.file.attached?
      @task.file.purge
    end
    if @task.update(task_params)
      redirect_to @task, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "Task was successfully deleted."
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id]) # Only current user's tasks will be accessed
  end

  def task_params
    params.require(:task).permit(:title, :description, :completed, :file, :remove_file)
  end
end