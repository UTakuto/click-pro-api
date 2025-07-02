class CreatePhotos < ActiveRecord::Migration[7.1]
  def change
    create_table :photos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :image_url
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
