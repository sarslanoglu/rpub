class AddVerbAndPathIndexToEndpoints < ActiveRecord::Migration[7.0]
  def change
    add_index :endpoints, [:verb, :path], unique: true
  end
end
