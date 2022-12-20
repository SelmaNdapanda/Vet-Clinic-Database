/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) 
VALUES 
('Agumon', '2020-02-03', 0, 'TRUE', 10.23),
('Gabumon', '2018-11-15', 2, 'TRUE', 8),
('Pikachu', '2021-01-07', 1, 'FALSE', 15.04),
('Devimon', '2017-05-12', 5, 'TRUE', 11);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) 
VALUES 
('Charmander', '2020-02-08', 0, 'FALSE', -11),
('Plantmon', '2021-11-15', 2, 'TRUE', -5.7),
('Squirtle', '1993-04-02', 3, 'FALSE', -12.13),
('Angemon', '2005-06-12', 1, 'TRUE', -45),
('Boarmon', '2005-06-07', 7, 'TRUE', 20.4),
('Blossom', '1998-10-13', 3, 'TRUE', 17),
('Ditto', '2022-05-14', 4, 'TRUE', 22);

INSERT INTO owners (full_name, age) 
VALUES 
('Sam Smith', 34),
('Jennifer Orwell', 19),
('Bob', 45),
('Melody Pond', 77),
('Dean Winchester', 14),
('Jodie Whittaker', 38);

INSERT INTO species (name) 
VALUES 
('Pokemon'),
('Digimon');

UPDATE animals
SET species_id = 2
WHERE name LIKE '%mon';

UPDATE animals
SET species_id = 1
WHERE name NOT LIKE '%mon';

UPDATE animals
SET owner_id = 
    (SELECT id FROM owners WHERE full_name = 'Sam Smith')
    WHERE name = 'Agumon';

UPDATE animals
SET owner_id = 
    (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
    WHERE name IN ('Gabumon', 'Pikachu');

UPDATE animals
SET owner_id = 
    (SELECT id FROM owners WHERE full_name = 'Bob')
    WHERE name IN ('Devimon', 'Plantmon');

UPDATE animals
SET owner_id = 
    (SELECT id FROM owners WHERE full_name = 'Melody Pond')
    WHERE name IN ('Charmander', 'Squirtle', 'Blossom');

UPDATE animals
SET owner_id = 
    (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
    WHERE name IN ('Angemon', 'Boarmon'); 

-- Insert data for vets
INSERT INTO vets (name, age, date_of_graduation) 
VALUES 
('William Tatcher', 45, '2000-04-23'),
('Maisy Smith', 26, '2019-01-17'),
('Stephanie Mendez', 64, '1981-05-04'),
('Jack Harkness', 38, '2008-06-08');    

-- Insert data for specialties
INSERT INTO specializations (vets_id, species_id) 
VALUES 
(1, 1),
(3, 2),
(3, 1),
(4, 2);

-- Insert data for visits
INSERT INTO visits (animal_id, vet_id, date_of_visit) 
VALUES 
(5, 1, '2020-05-24'),
(5, 3, '2020-07-22'),
(6, 4, '2021-02-02'),
(9, 2, '2020-01-05'),
(9, 2, '2020-03-08'),
(9, 2, '2020-05-14'),
(7, 3, '2021-05-04'),
(3, 4, '2021-02-24'),
(1, 2, '2019-12-21'),
(1, 1, '2020-08-10'),
(1, 2, '2021-04-07'),
(4, 3, '2019-09-29'),
(2, 4, '2020-10-03'),
(2, 4, '2020-11-04'),
(8, 2, '2019-01-24'),
(8, 2, '2019-05-15'),
(8, 2, '2020-02-27'),
(8, 2, '2020-08-03'),
(10, 3, '2020-05-24'),
(10, 1, '2021-01-11');


-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animal_id, vet_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';