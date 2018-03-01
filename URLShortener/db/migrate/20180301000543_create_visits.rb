class CreateVisits < ActiveRecord::Migration[5.1]
  def change
    create_table :visits do |t|
      t.integer :visitor_id
      t.integer :short_url_id 

      t.timestamps
    end
  end
end
