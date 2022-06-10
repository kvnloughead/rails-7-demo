# This file is created when you `rails generate` a User model

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      # create columns for the listed properties in the table
      t.string :name
      t.string :email

      # creates the `created_at` and `updated_at` columns
      t.timestamps 
    end
  end
end
