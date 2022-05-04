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


CREATE TABLE medical_histories_treaments (
    medical_history_id int,
    treament_id int,
    CONSTRAINT fk_medical_history FOREIGN KEY(medical_history_id) REFERENCES medical_histories(id),
    CONSTRAINT fk_treament FOREIGN KEY(treament_id) REFERENCES treaments(id)
);

CREATE TABLE invoices (
    id SERIAL PRIMARY KEY,
    total_amount DECIMAL,
    generated_at TIMESTAMP,
    payed_at TIMESTAMP,
    medical_history_id INT,
    CONSTRAINT fk_medical_history FOREIGN KEY(medical_history_id) REFERENCES medical_histories(id)
);

CREATE TABLE invoice_items (
    id SERIAL PRIMARY KEY,
    unit_price DECIMAL,
    quantity INT,
    total_price DECIMAL,
    invoice_id INT,
    treament_id INT,
    CONSTRAINT fk_invoices FOREIGN KEY(invoice_id) REFERENCES invoices(id),
    CONSTRAINT fk_treatment FOREIGN KEY(treament_id) REFERENCES treaments(id)
);

--------FK INDEXES----
CREATE INDEX medical_histories_patient_id_index ON medical_histories(patient_id);
CREATE INDEX medical_histories_treaments_medical_history_id_index ON medical_histories_treaments(medical_history_id);
CREATE INDEX medical_histories_treaments_treament_id_index ON medical_histories_treaments(treament_id);
CREATE INDEX invoice_items_index ON invoice_items(invoice_id);
CREATE INDEX invoices_medical_history_id_index ON invoices (medical_history_id);
CREATE INDEX invoice_items_treatments_id_index ON invoice_items(treament_id);
