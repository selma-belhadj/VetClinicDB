/* Populate database with sample data. */

INSERT INTO animals(name,date_of_birth,escape_attempts,neutered,weight_kg) VALUES 
('Agumon', '2020-02-03', 0, true, 10.23 ),
('Gabumon', '2018-11-03', 2, true, 8 ),
('Pikachu', '2021-01-07', 1, false, 15.04),
('Devimon', '2017-05-12',  5, true, 11 );

/*Inserting new data to table*/

INSERT INTO animals(name,date_of_birth,escape_attempts,neutered,weight_kg) VALUES 
('Charmander', '2020-02-08', 0, false, -11),
('Plantmon', '2022-11-15', 2, true, -5.7 ),
('Squirtle', '1993-04-02', 3, false, -12.13),
('Angemon', '2005-06-12', 1, true, -45),
('Boarmon', '2005-06-07', 7, true, 20.4),
('Blossom', '1998-10-13', 3, true, 17),
('Ditto', '1998-05-14', 4, true, 22);

/* Setting the species to unspecified*/
BEGIN; -- start transaction

UPDATE animals SET species = 'unspecified';

--verify the changes were made
SELECT * FROM animals;
--rollback changes made to species
ROLLBACK;

--verify that thet changes were rolledback
SELECT * FROM animals;

/* Adding the correct species */
BEGIN;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

COMMIT;

--Verify that change was made and persists after commit.
SELECT * FROM animals;

/* Deleting all animals */
BEGIN;

DELETE FROM animals;

-- Verify that the animnals table is empty
SELECT * FROM animals;

ROLLBACK;

--verify that thet changes were rolledback
SELECT * FROM animals;

-- savepoint
BEGIN;

DELETE FROM animals WHERE date_of_birth > '2022-01-01';

SAVEPOINT save_point;

UPDATE animals SET weight_kg = weight_kg * -1;

ROLLBACK TO save_point;

UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

COMMIT;

-- Insert data into the owners table
INSERT INTO owners(full_name, age) VALUES 
('Sam Smith', 34),
('Jennifer Orwell', 19),
('Bob', 45),
('Melody Pond', 77),
('Dean Winchester', 14),
('Jodie Whittaker', 38);

-- Insert data into the species table
INSERT INTO species(name) VALUES 
('Pokemon'),
('Digimon');

-- Modify inserted animals so it includes the species_id value
UPDATE animals
    set species_id = (SELECT id from species where name = 'Digimon')
    WHERE name LIKE '%mon';

UPDATE animals
    set species_id = (SELECT id from species where name = 'Pokemon')
    WHERE species_id IS NULL;

-- Modify inserted animals to include owner information (owner_id)
UPDATE animals
    set owner_id = (SELECT id from owners where full_name = 'Sam Smith')
    WHERE name='Agumon';

UPDATE animals
    set owner_id = (SELECT id from owners where full_name = 'Jennifer Orwell')
    WHERE name='Gabumon' AND name='Pikachu';

UPDATE animals
    set owner_id = (SELECT id from owners where full_name = 'Bob')
    WHERE name IN ('Devimon','Plantmon');

UPDATE animals
    set owner_id = (SELECT id from owners where full_name = 'Melody Pond')
    WHERE name IN ('Charmander','Squirtle', 'Blossom');

UPDATE animals
    set owner_id = (SELECT id from owners where full_name = 'Dean Winchester')
    WHERE name IN ('Angemon','Boarmon');

-- Inserting data into vets table
INSERT INTO
  vets
    (name, age, date_of_graduation)
  VALUES
    ('William Tatcher', 45, '2000-04-23'),
    ('Maisy Smith', 26, '2019-01-17'),
    ('Stephanie Mendez', 64, '1981-05-04'),
    ('Jack Harkness', 38, '2008-06-08');

/* Inserting data into Specializations table */

-- Vet William Tatcher is specialized in Pokemon.
INSERT INTO 
  specializations(species_id, vets_id)
  VALUES (
    (SELECT id FROM species WHERE name = 'Pokemon'),
    (SELECT id FROM vets WHERE name = 'William Tatcher')
  );

-- Vet Stephanie Mendez is specialized in Digimon and Pokemon.
INSERT INTO 
  specializations(species_id, vets_id)
  VALUES (
      (SELECT id FROM species WHERE name = 'Digimon'),
      (SELECT id FROM vets WHERE name = 'Stephanie Mendez')
  );

INSERT INTO 
  specializations(species_id, vets_id)
  VALUES (
      (SELECT id FROM species WHERE name = 'Pokemon'),
      (SELECT id FROM vets WHERE name = 'Stephanie Mendez')
  );

-- Vet Jack Harkness is specialized in Digimon.
INSERT INTO 
  specializations(species_id, vets_id)
  VALUES (
      (SELECT id FROM species WHERE name = 'Digimon'),
      (SELECT id FROM vets WHERE name = 'Jack Harkness')
  );


-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animals_id, vets_id, date_visit) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';