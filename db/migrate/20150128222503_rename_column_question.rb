class RenameColumnQuestion < ActiveRecord::Migration
  def change
    rename_column(:questions, :question, :description)
  end
end
