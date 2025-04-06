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