class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :vote_type
      t.references :user, null: false, foreign_key: true
      t.references :votable, polymorphic: true, null: false
    end
    add_index :votes, [:votable_id, :votable_type, :user_id], unique: true
  end
end
