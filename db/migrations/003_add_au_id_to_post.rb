Sequel.migration do
  up do
    alter_table :posts do
      add_column :au_id, Integer, null: false
    end
  end

  down do
    drop_column :au_id
  end
end