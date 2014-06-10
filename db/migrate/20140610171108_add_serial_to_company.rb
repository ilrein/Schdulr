class AddSerialToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :serial, :string
  end
end
