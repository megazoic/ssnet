Sequel.migration do
  up do
    create_table :edit_histories do
      primary_key :id
      Integer :post, null: false
      Integer :au_id, null: false
      DateTime :created_at, null: false
    end
  end

  down{drop_table :edit_histories}
end