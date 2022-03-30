class CreateEndpoints < ActiveRecord::Migration[7.0]
  def change
    create_table :endpoints, :id => false do |t|
      t.string :id, null: false, unique: true
      t.string :verb, null: false
      t.string :path, null: false
      t.jsonb :response, null: false

      t.timestamps
    end
  end
end
