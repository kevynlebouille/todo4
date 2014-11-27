class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :label
      t.string :username
      t.integer :position

      t.timestamps
    end
  end
end
