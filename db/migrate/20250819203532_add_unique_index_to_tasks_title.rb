class AddUniqueIndexToTasksTitle < ActiveRecord::Migration[8.0]
  def change
    add_index :tasks, :title, unique: true
  end
end