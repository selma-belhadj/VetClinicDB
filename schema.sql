/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    name  varchar(100),          
    date_of_birth  date,           
    escape_attempts int,          
    neutered  boolean,
    weight_kg real
);
