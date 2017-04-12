DROP TABLE IF EXISTS ingredients_table;

CREATE TABLE ingredients_table (
  id SERIAL PRIMARY KEY,
  ingredients_place VARCHAR(255),
  ingredients_name VARCHAR(255)
);
