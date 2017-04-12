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
    insert_ingredient = "INSERT INTO ingredients_table (ingredients_place, ingredients_name) VALUES ($1, $2)"
    values = [row[0], row[1]]
    conn.exec_params(insert_ingredient, values)
  end
end

select_ingredients = "SELECT ingredients_place, ingredients_name FROM ingredients_table"
ingredients = db_connection do |conn|
  conn.exec(select_ingredients)
end

ingredients_array = []
ingredients.to_a.each do |ingredient|
  ingredient.each do |key, value|
    ingredients_array << value
  end
end

puts "#{ingredients_array[0]}. #{ingredients_array[1]}"
puts "#{ingredients_array[2]}. #{ingredients_array[3]}"
puts "#{ingredients_array[4]}. #{ingredients_array[5]}"
puts "#{ingredients_array[6]}. #{ingredients_array[7]}"
