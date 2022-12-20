/* Database schema to keep the structure of entire database. */

CREATE TABLE animals(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(100) NOT NULL,
  date_of_birth DATE NOT NULL,
  escape_attempts INT NOT NULL,
  neutered BOOLEAN NOT NULL,
  weight_kg DECIMAL NOT NULL,
  PRIMARY KEY(id)
);

ALTER TABLE animals
ADD COLUMN species VARCHAR(100); 

CREATE TABLE owners(
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  age INT NOT NULL
);

CREATE TABLE species(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

ALTER TABLE animals
ADD COLUMN id SERIAL PRIMARY KEY;

ALTER TABLE animals
DROP COLUMN species;

ALTER TABLE animals
ADD species_id INT REFERENCES species(id);

ALTER TABLE animals
ADD owner_id INT REFERENCES owners(id);

--Create table vets
CREATE TABLE vets(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  age INT NOT NULL,
  date_of_graduation DATE NOT NULL
);

--Create a "join table" called specializations to handle the many-to-many relationship between species and vets
CREATE TABLE specializations(
  vets_id INT REFERENCES vets(id),
  species_id INT REFERENCES species(id)
);

--Create a "join table" called visits to handle the many-to-many relationship between animals and vets
CREATE TABLE visits(
  vet_id INT REFERENCES vets(id),
  animal_id INT REFERENCES animals(id),
  date_of_visit DATE
);

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);