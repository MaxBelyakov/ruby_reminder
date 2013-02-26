class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.date :last_date
      t.integer :position
      t.integer :red_val

      t.timestamps
    end
  end
end
