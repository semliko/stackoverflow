class CreateAwards < ActiveRecord::Migration[6.0]
  def change
    create_table :awards do |t|
      t.string :name
      t.references :awardable, polymorphic: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
