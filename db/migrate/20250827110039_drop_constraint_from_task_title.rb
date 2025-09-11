class DropConstraintFromTaskTitle < ActiveRecord::Migration[8.0]
  def change
    remove_index :tasks, :title if index_exists?(:tasks, :title)
    add_index :tasks, [:user_id, :title], unique: true
  end
end
