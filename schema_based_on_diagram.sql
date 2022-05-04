CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(220),
    date_of_birth DATE
);

CREATE TABLE medical_histories (
    id SERIAL PRIMARY KEY,
    admitted_at TIMESTAMP,
   patient_id INT,
   status VARCHAR(220),
   CONSTRAINT fk_patient FOREIGN KEY(patient_id) REFERENCES patients(id)
);

CREATE TABLE treaments (
    id SERIAL PRIMARY KEY,
    type VARCHAR(220),
    name VARCHAR(220)
);