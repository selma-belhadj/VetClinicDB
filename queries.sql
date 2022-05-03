/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name = 'Luna';

-- Find all animals whose name ends in "mon".
SELECT * from animals WHERE name like '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT * from animals WHERE date_of_birth between '2016-01-01' and '2019-12-31' ;

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name from animals WHERE neutered='true' and escape_attempts < 3 ;

-- List date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth from animals WHERE name='Agumon' or name='Pikachu' ;

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts from animals WHERE weight_kg > 10.5 ;

-- Find all animals that are neutered.
SELECT * from animals WHERE neutered='true' ;

-- Find all animals not named Gabumon.
SELECT * from animals WHERE name<>'Gabumon' ;

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * from animals WHERE weight_kg >= 10.4 and  weight_kg <= 17.3;

/* Count number of animals */
SELECT COUNT(*) FROM animals;

/* Count number of animals that have not attempted escape */
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

/* Avarage weight of animals */
SELECT AVG(weight_kg) FROM animals;

/* Sum escape attempts and compare between neutered and non-neutered */
SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;

/* Minimum and maximum weights of each type of animal*/
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

/* Average number of escape attempts per animal type of those born between 1990 and 2000 */
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth 
BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

/* Write queries (using JOIN) */

-- What animals belong to Melody Pond?
SELECT * FROM
    animals a 
    JOIN owners o
    ON a.owner_id = o.id 
    WHERE full_name='Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT * FROM
    animals a 
    JOIN species s
    ON a.species_id = s.id 
    WHERE s.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT * FROM
    animals a 
    LEFT JOIN owners o
    ON a.owner_id = o.id;

-- How many animals are there per species?
SELECT s.name as species, COUNT(*) FROM
    animals a 
    JOIN species s
    ON a.species_id = s.id 
    GROUP BY s.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT * FROM
    animals a 
    JOIN species s
    ON a.species_id = s.id 
    JOIN owners o
    ON a.owner_id = o.id 
    WHERE s.name='Digimon' and o.full_name='Jennifer Orwell';


-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT * FROM
    animals a 
    JOIN owners o
    ON a.owner_id = o.id 
    WHERE o.full_name='Dean Winchester' and a.escape_attempts<=0;

-- Who owns the most animals?
SELECT o.full_name, count (*) as animals FROM
    animals a 
    JOIN owners o
    ON a.owner_id = o.id 
    GROUP BY a.owner_id,o.full_name 
    ORDER BY animals DESC 
    LIMIT(1);

---------------
-- Who was the last animal seen by William Tatcher?
SELECT a.name as animal_name, v.name as vet_name, vs.date_visit FROM 
    visits vs  JOIN vets v ON v.id= vs.vets_id 
    JOIN animals a ON a.id = vs.animals_id 
    WHERE v.name = 'William Tatcher'
    ORDER BY vs.date_visit DESC
    LIMIT(1);
-- How many different animals did Stephanie Mendez see?
SELECT v.name as vet_name, count(vs.date_visit) as nb_visits FROM 
    visits vs  JOIN vets v ON v.id= vs.vets_id 
    WHERE v.name = 'Stephanie Mendez'
    GROUP BY v.name;
-- List all vets and their specialties, including vets with no specialties.

SELECT 
  sp.species_id, 
  sp.vets_id, 
  v.name AS vet_name, 
  s.name AS species_name  
  FROM specializations sp FULL OUTER JOIN species s ON s.id = sp.species_id
  FULL OUTER JOIN vets v 
    ON v.id = sp.vets_id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT 
  a.name, 
  v.name AS vet_name, 
  vs.date_visit
  FROM visits vs LEFT JOIN animals a ON a.id = vs.animals_id
  LEFT JOIN vets v 
    ON v.id = vs.vets_id
  WHERE 
    v.name = 'Stephanie Mendez' AND 
    vs.date_visit 
    BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT a.name, COUNT(*) 
  FROM visits vs INNER JOIN animals a ON a.id = vs.animals_id
  GROUP BY a.name
  ORDER BY COUNT DESC
  LIMIT 1;
-- Who was Maisy Smith's first visit?
SELECT 
  a.name AS animal_name, 
  v.name AS vet_name,
  vs.date_visit
  FROM visits vs LEFT JOIN animals a ON a.id = vs.animals_id
  LEFT JOIN vets v ON v.id = vs.vets_id
  WHERE v.name = 'Maisy Smith'
  ORDER BY vs.date_visit ASC
  LIMIT 1;
-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT 
  a.id AS animal_id,
  a.name AS animal_name,
  a.date_of_birth,
  v.id AS vet_id,
  v.name AS vet_name, 
  v.age AS vet_age,
  date_visit
  FROM visits vs INNER JOIN animals a ON a.id = vs.animals_id
  INNER JOIN vets v
  ON v.id = vs.vets_id;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT 
  v.name AS vet_name,
  COUNT(*)
  FROM visits vs LEFT JOIN vets v ON v.id = vs.vets_id
  LEFT JOIN specializations sp 
    ON sp.vets_id = vs.vets_id
  WHERE sp.species_id IS NULL
  GROUP BY v.name;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT 
  v.name AS vet_name,
  s.name AS species_name,
  COUNT(s.name)
  FROM visits vs LEFT JOIN animals a ON a.id = vs.animals_id
  LEFT JOIN vets v 
    ON v.id = vs.vets_id
  LEFT JOIN species s
    ON s.id = a.species_id
  WHERE v.name = 'Maisy Smith'
  GROUP BY v.name, s.name
  ORDER BY COUNT DESC
  LIMIT 1;

  
-- EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4;
EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2;
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';