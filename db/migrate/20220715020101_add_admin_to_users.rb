# Add a boolean admin field to users db
# Generated with `rails generate migration add_admin_to_users admin:boolean`
# Added `default: false` separately.

class AddAdminToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
