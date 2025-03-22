# db/migrate/[timestamp]_create_urls.rb
class CreateUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :urls do |t|
      t.string :original
      t.string :shortened, unique: true

      t.timestamps
    end
  end
end
