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
