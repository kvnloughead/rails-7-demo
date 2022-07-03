# Adds index to User.email to prevent full page scans. This is necessary
# because we are using :email to retrieve users from DB.
class AddIndexToUserEmail < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email, unique: true
  end
end
