CREATE DATABASE clinic;

CREATE TABLE patients(
    id SERIAL PRIMARY KEY,
    name VARCHAR(120),
    date_of_birth DATE
);

CREATE TABLE medical_histories (
    id SERIAL PRIMARY KEY,
    admitted_at TIMESTAMP NOT NULL DEFAULT NOW(),
    patient_id int REFERENCES patients(id),
    status VARCHAR(120)
);


CREATE TABLE invoices (
    id SERIAL PRIMARY KEY,
    total_amount DECIMAL,
    generated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    payed_at TIMESTAMP,
    medical_history_id int UNIQUE REFERENCES medical_histories (id)
);

CREATE TABLE invoices_items (
    id SERIAL PRIMARY KEY,
    unit_price DECIMAL,
    quantity INT,
    total_price DECIMAL,
    invoice_id INT REFERENCES invoices (id)
);

CREATE TABLE treatments (
    id SERIAL PRIMARY KEY,
    type VARCHAR(120),
    name VARCHAR(120)
);

--Create a "join table" called medical_histories_treatments to handle the many-to-many relationship between medical_histories and treatment

CREATE TABLE medical_histories_treatments (
    medical_history__id INT REFERENCES medical_histories(id),
    treatments_id INT REFERENCES treatments(id)
);

-- Create indexes on all tables: 

CREATE INDEX medical_histories_index ON medical_histories (patient_id);
CREATE INDEX invoices_index ON invoices (medical_history_id);
CREATE INDEX invoice_items_index ON invoice_items (invoice_id);
CREATE INDEX ON medical_histories_has_treatments (medical_history_id);
CREATE INDEX ON medical_histories_has_treatments (treatment_id);