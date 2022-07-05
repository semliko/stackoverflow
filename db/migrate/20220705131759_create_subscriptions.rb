class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.references :subscriwable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
