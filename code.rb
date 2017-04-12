require 'pg'
require 'csv'
system "psql ingredients < schema.sql"

def db_connection
  begin
    connection = PG.connect(dbname: "ingredients")
    yield(connection)
  ensure
    connection.close
  end
end

# your code, here

CSV.foreach("ingredients.csv", headers: false) do |row|
  db_connection do |conn|
    insert_ingredient = "INSERT INTO ingredients_table (name) VALUES ($1)"
    values = [row[1]]
    conn.exec_params(insert_ingredient, values)
  end
end

select_ingredients = "SELECT * FROM ingredients_table"
ingredients = db_connection do |conn|
  conn.exec(select_ingredients)
end

ingredients.to_a.each do |ingredient|
  puts "#{ingredient["id"]}. #{ingredient["name"]}"
end
