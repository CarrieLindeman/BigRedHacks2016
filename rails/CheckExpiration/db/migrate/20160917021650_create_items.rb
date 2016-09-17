class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.date :expiration
      t.boolean :removed

      t.timestamps null: false
    end
  end
end
