-- HOSPITAL Patients Management Systrm
CREATE DATABASE Hospital_System;
USE hospital_system;

-- Departments table
CREATE TABLE departments (
	department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    description TEXT
);
-- Doctors table
CREATE TABLE doctors (
	doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    doc_first_name VARCHAR(50) NOT NULL,
    doc_last_name VARCHAR(50) NOT NULL,
    department_id INT NOT NULL,
    doc_contact_number VARCHAR(10),
    doc_email VARCHAR(50),
    Specialization TEXT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Patients table
CREATE TABLE PATIENTS (
	patient_id INT AUTO_INCREMENT PRIMARY KEY,
	pat_first_name VARCHAR(50) NOT NULL,
    pat_last_name VARCHAR(50) NOT NULL,
	date_of_birth DATE NOT NULL,
    pat_address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    insurance_info VARCHAR(50) NOT NULL,
	email VARCHAR(50),
    contact_number VARCHAR(10) NOT NULL,
    user_name VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(50) NOT NULL,
	registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    depature_date DATETIME, 
	is_active BOOLEAN DEFAULT TRUE
    );
    
-- Appointments table

CREATE TABLE appointments (
appointment_id INT AUTO_INCREMENT PRIMARY KEY,
patient_id INT NOT NULL,
doctor_id INT NOT NULL,
department_id INT NOT NULL,
appointment_date DATE NOT NULL,
appointment_time TIME NOT NULL,
status ENUM('pending','cancelled','completed') DEFAULT 'pending',
create_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Medical records table

CREATE TABLE medical_records(
	record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_id INT NOT NULL,
    diagnosis TEXT,
    treatment TEXT,
    medicines_prescribed TEXT,
    allergies TEXT,
    record_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    note TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
	FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- Feedback table
CREATE TABLE feedback (
	feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);


-- Insert departments
INSERT INTO departments (department_name, location, description) VALUES
('General Practice', 'Ground Floor', 'Primary care for all patients'),
('Cardiology', 'First Floor', 'Heart and cardiovascular system specialists'),
('Pediatrics', 'Second Floor', 'Child healthcare specialists'),
('Orthopedics', 'First Floor', 'Bone and joint specialists');

-- Insert doctors
INSERT INTO doctors (doc_first_name, doc_last_name, department_id, specialization, doc_contact_number, doc_email) VALUES
('Sarah', 'Johnson', 1, 'General Practitioner', '7123456789', 's.johnson@hospital.com'),
('Michael', 'Brown', 2, 'Cardiologist', '7234567890', 'm.brown@hospital.com'),
('Emily', 'Davis', 3, 'Pediatrician', '7345678901', 'e.davis@hospital.com'),
('David', 'Wilson', 4, 'Orthopedic Surgeon', '7456789012', 'd.wilson@hospital.com');
    
-- Insert patients
INSERT INTO patients (pat_first_name, pat_last_name, date_of_birth, pat_address, city, postcode, insurance_info, email, contact_number, user_name, password_hash) VALUES
('John', 'Smith', '1985-05-15', '123 Main St', 'London', 'SW1A 1AA', 'NHS123456', 'john.smith@email.com', '7555123456', 'jsmith', '$2a$10$xJwL5v5zJz6Z1Z1Z1Z1Z1e'),
('Emma', 'Williams', '1990-08-22', '456 Oak Ave', 'Manchester', 'M1 1AB', 'PrivateXYZ789', 'emma.w@email.com', '7555234567', 'ewilliams', '$2a$10$yKwM6w6yKz7A2A2A2A2A2f'),
('James', 'Taylor', '1978-03-10', '789 Pine Rd', 'Birmingham', 'B1 1BC', 'NHS987654', NULL, '7555345678', 'jtaylor', '$2a$10$zLxN7x7zLz8B3B3B3B3B3g');
 
 -- Insert appointments
INSERT INTO appointments (patient_id, doctor_id, department_id, appointment_date, appointment_time, status) VALUES
(1, 1, 1, '2023-06-15', '09:00:00', 'completed'),
(2, 3, 3, '2023-06-16', '10:30:00', 'pending'),
(3, 2, 2, '2023-06-14', '14:00:00', 'completed'),
(1, 4, 4, '2023-06-20', '11:15:00', 'cancelled');
 
 -- Insert medical records
INSERT INTO medical_records (patient_id, doctor_id, appointment_id, diagnosis, treatment, medicines_prescribed, allergies) VALUES
(1, 1, 1, 'Common cold', 'Rest and hydration', 'Paracetamol 500mg', 'Penicillin'),
(3, 2, 3, 'High blood pressure', 'Lifestyle changes', 'Amlodipine 5mg', 'None known');


-- Insert feedback
INSERT INTO feedback (appointment_id, rating, comments) VALUES
(1, 4, 'Dr. Johnson was very thorough and helpful.');