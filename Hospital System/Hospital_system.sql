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


USE hospital_system;

-- Register a new patient
DROP PROCEDURE IF EXISTS register_patient;
DELIMITER //
CREATE PROCEDURE register_patient(
IN p_pat_first_name VARCHAR(50),
IN p_pat_last_name VARCHAR(50),
IN p_date_of_birth DATE,
IN p_pat_address TEXT,
IN p_city VARCHAR(50),
IN p_postcode VARCHAR(10),
IN p_insurance_info VARCHAR(50),
IN p_user_name VARCHAR(50),
IN p_password_hash VARCHAR(50),
IN p_email VARCHAR(50),
IN p_contact_number VARCHAR(10),
OUT p_message VARCHAR(255)
)
BEGIN
DECLARE patient_count INT;
-- Check if patient with same name and phone already exists
SELECT COUNT(*) INTO patient_count
FROM patients
WHERE pat_first_name = p_pat_first_name
AND pat_last_name = p_pat_last_name
AND contact_number = p_contact_number;

IF patient_count >0 THEN
	 -- Patient exists, set warning message
     SET p_message = concat('Warning: Patient already exists with name "', 
                             p_pat_first_name, ' ', p_pat_last_name, 
                             '" and phone number "', p_contact_number, '"');
ELSE 
 -- Insert new patient
 INSERT INTO patients (pat_first_name,pat_last_name,date_of_birth,pat_address,
		city,postcode,insurance_info,user_name,password_hash,email,contact_number)
        VALUES (p_pat_first_name,p_pat_last_name,p_date_of_birth,p_pat_address,
		p_city,p_postcode,p_insurance_info,p_user_name,p_password_hash,p_email,p_contact_number);
 -- Set success message
 
 SET p_message = concat('Patient "', p_pat_first_name, ' ', p_pat_last_name, 
                             '" registered successfully with ID: ',LAST_INSERT_ID());

END IF;

-- Return the message (can be selected by caller)
SELECT p_message AS result;
END //
DELIMITER ;

select * from patients;
-- First call (successful registration)
CALL register_patient('John', 'Doe', '1990-01-01', '123 Main St', 
                     'Anytown', '12345', 'ABC Insurance', 'johndoe', 
                     'hashedpass', 'john@example.com', '5551234567', @message);
                     
CALL register_patient('simon', 'vedha', '1990-01-01', 'Rc Street', 
                     'UPM', '625533', 'ABC Insurance', 'sahasimon', 
                     'simonvedha', 'simon.v@gmail.com', '8148957080', @message);
                     
CALL register_patient('steve', '', '1990-01-03', 'condonment', 
                     'Trichy', '620002', 'ABC Insurance', 'stave3', 
                     'steve', 'steve@gmail.com', '1234567890', @message);					


-- Book an appointment

DELIMITER //
CREATE PROCEDURE book_appointment(
IN p_patient_id INT,
IN p_doctor_id INT,
IN p_department_id INT,
IN p_appointment_data DATE,
IN p_appointment_time TIME)
BEGIN
INSERT INTO appointments (patient_id,doctor_id,department_id,appointment_date,appointment_time) 
VALUE (p_patient_id,p_doctor_id,p_department_id,appointment_data,appointment_time);
END //
DELIMITER ;

-- Cancel an appointment

DELIMITER //
CREATE PROCEDURE cancel_appointment(IN p_appointment_id INT)
BEGIN
UPDATE appointments
SET status = 'Cancelled' , updated_at = NOW()
WHERE appointment_id = p_appointment_id;
END //
DELIMITER ;

-- Get patient medical history

DELIMITER //
CREATE PROCEDURE get_patient_history(IN p_patient_id INT)
BEGIN
    SELECT 
        mr.record_id,
        mr.record_date,
        CONCAT(d.doc_first_name, ' ', d.doc_last_name) AS doctor_name,
        dep.department_name,
        a.appointment_date,
        a.appointment_time,
        mr.diagnosis,
        mr.treatment,
        mr.medicines_prescribed,
        mr.allergies,
        mr.notes
    FROM medical_records mr
    JOIN doctors d ON mr.doctor_id = d.doctor_id
    JOIN departments dep ON d.department_id = dep.department_id
    LEFT JOIN appointments a ON mr.appointment_id = a.appointment_id
    WHERE mr.patient_id = p_patient_id
    ORDER BY mr.record_date DESC;
END //
DELIMITER ;

-- Get doctor availability
DELIMITER //
CREATE PROCEDURE get_doctor_availability(IN p_doctor_id INT, IN p_date DATE)
BEGIN
    SELECT appointment_time
    FROM appointments
    WHERE doctor_id = p_doctor_id 
    AND appointment_date = p_date
    AND status != 'cancelled'
    ORDER BY appointment_time;
END //
DELIMITER ;


-- Sample Queries
-- Find all active patients

SELECT * FROM patients WHERE is_active =TRUE;


-- Find all appointments for a specific patient

SELECT 
p.pat_first_name,
p.pat_last_name,
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    CONCAT(d.doc_first_name, ' ', d.doc_last_name) AS doctor_name,
    dep.department_name,
    a.status
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN departments dep ON a.department_id = dep.department_id
JOIN patients p ON p.patient_id = a.patient_id
WHERE a.patient_id = 1
ORDER BY a.appointment_date DESC, a.appointment_time DESC;


-- Find all completed appointments with feedback
SELECT 
    a.appointment_id,
    a.appointment_date,
    CONCAT(p.pat_first_name, ' ', p.Pat_last_name) AS patient_name,
    CONCAT(d.doc_first_name, ' ', d.doc_last_name) AS doctor_name,
    f.rating,
    f.comments
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN feedback f ON a.appointment_id = f.appointment_id
WHERE a.status = 'completed'
ORDER BY a.appointment_date DESC;


SELECT 
    p.patient_id,
    CONCAT(p.pat_first_name, ' ', p.pat_last_name) AS patient_name,
    p.date_of_birth,
    mr.allergies
FROM patients p
JOIN medical_records mr ON p.patient_id = mr.patient_id
WHERE mr.allergies LIKE '%Penicillin%';

-- Get average doctor ratings
SELECT 
    d.doctor_id,
    CONCAT(d.doc_first_name, ' ', d.doc_last_name) AS doctor_name,
    d.specialization,
    AVG(f.rating) AS average_rating,
    COUNT(f.feedback_id) AS feedback_count
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
LEFT JOIN feedback f ON a.appointment_id = f.appointment_id
GROUP BY d.doctor_id
ORDER BY average_rating DESC;