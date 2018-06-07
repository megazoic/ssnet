Sequel.migration do
  up do
    create_table :posts do
      primary_key :id
      String :title
      String :body, :text=>true
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down{drop_table :posts}
end