/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered IS true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered IS true;
SELECT * FROM animals WHERE name NOT IN ('Gabumon');
SELECT * FROM animals WHERE weight_kg >= 10.4  AND weight_kg <= 17.3;

-- Update the animals table by setting the species column to unspecified, then roll back
BEGIN;

UPDATE animals 
SET species = 'unspecified';

SELECT * FROM animals;

ROLLBACK;
SELECT * FROM animals;

-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
BEGIN;

UPDATE animals 
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals 
SET species = 'pokemon'
WHERE species IS NULL;

SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

-- delete all records in the animals table, then roll back the transaction.
BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;

-- Delete all animals born after Jan 1st, 2022.
-- Create a savepoint for the transaction.
-- Update all animals' weight to be their weight multiplied by -1.
-- Rollback to the savepoint
-- Update all animals' weights that are negative to be their weight multiplied by -1.
BEGIN;

DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

SAVEPOINT born_before_Jan2022;
UPDATE animals 
SET weight_kg = weight_kg * -1;

ROLLBACK TO born_before_Jan2022;

UPDATE animals 
SET weight_kg = weight_kg * -1 
WHERE weight_kg < 0;

COMMIT;
SELECT * FROM animals;

--how many animals are there?
SELECT COUNT(*) FROM animals;
--how many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
--what is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;
--who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;
--what is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
--what is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;


--What animals belong to Melody Pond?
SELECT name FROM animals A
INNER JOIN owners O
ON A.owner_id = O.id
WHERE O.full_name = 'Melody Pond';

--List of all animals that are pokemon (their type is Pokemon).
SELECT A.name FROM animals A
INNER JOIN species S
ON A.species_id = S.id
WHERE S.name = 'Pokemon';

--List all owners and their animals, remember to include those that don't own any animal.
SELECT full_name, name FROM owners O
LEFT JOIN animals A
ON A.owner_id = O.id;

--How many animals are there per species?
SELECT COUNT(*), S.name FROM animals A
INNER JOIN species S
ON A.species_id = S.id
GROUP BY S.name;

--List all Digimon owned by Jennifer Orwell.
SELECT A.name FROM animals A
INNER JOIN species S ON A.species_id = S.id
INNER JOIN owners O ON A.owner_id = O.id
WHERE O.full_name = 'Jennifer Orwell' AND S.name = 'Digimon';

--List all animals owned by Dean Winchester that haven't tried to escape.
SELECT name FROM animals A
INNER JOIN owners O ON A.owner_id = O.id
WHERE O.full_name = 'Dean Winchester' AND escape_attempts = 0;

--Who owns the most animals?
SELECT COUNT(*) as count, full_name FROM animals A
INNER JOIN owners O ON A.owner_id = O.id
GROUP BY O.full_name
ORDER BY count DESC;


--Who was the last animal seen by William Tatcher?
SELECT A.name FROM visits V
INNER JOIN animals A ON V.animal_id = A.id
INNER JOIN vets B ON V.vet_id = B.id
WHERE B.name = 'William Tatcher'
ORDER BY V.date_of_visit DESC LIMIT 1;

--How many different animals did Stephanie Mendez see?
SELECT COUNT(*) As animals FROM visits V
INNER JOIN animals A ON V.animal_id = A.id
INNER JOIN vets B ON V.vet_id = B.id
WHERE B.name = 'Stephanie Mendez';

--List all vets and their specialties, including vets with no specialties.
SELECT B.name AS vet, S.name AS species FROM specializations C
FULL OUTER JOIN vets B ON C.vets_id = B.id
FULL OUTER JOIN species S ON C.species_id = S.id;

--List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT A.name FROM visits V
INNER JOIN animals A ON V.animal_id = A.id
INNER JOIN vets B ON V.vet_id = B.id
WHERE B.name = 'Stephanie Mendez' AND date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

--What animal has the most visits to vets?
SELECT A.name FROM visits V
INNER JOIN animals A ON V.animal_id = A.id
GROUP BY A.name
ORDER BY COUNT(date_of_visit) DESC LIMIT 1;

--Who was Maisy Smith's first visit?
SELECT A.name FROM visits V
INNER JOIN animals A ON V.animal_id = A.id
INNER JOIN vets B ON V.vet_id = B.id
WHERE B.name = 'Maisy Smith'
ORDER BY V.date_of_visit LIMIT 1;

--Details for most recent visit: animal information, vet information, and date of visit.
SELECT A.name AS animal, B.name as vet, V.date_of_visit FROM visits V
INNER JOIN animals A ON A.id = V.animal_id
INNER JOIN vets B ON B.id = V.vet_id
ORDER BY date_of_visit DESC LIMIT 1;

--How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS visits FROM visits V
WHERE V.vet_id = (SELECT id FROM vets B
  INNER JOIN specializations C ON B.id != C.vets_id LIMIT 1);

--What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT S.name, COUNT(S.name) AS visits FROM animals A 
INNER JOIN visits V ON A.id = V.animal_id
INNER JOIN vets B ON V.vet_id = B.id
INNER JOIN species S ON A.species_id = S.id
WHERE B.name = 'Maisy Smith'
GROUP BY S.name
ORDER BY visits DESC LIMIT 1;