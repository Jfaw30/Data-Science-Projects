--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T4-mns-alter.sql

--Student ID:34194037
--Student Name:Sachin Shivaramaiah
--Unit Code:FIT9132
--Applied Class No: 02_OnCampus

/* Comments for your marker:
a) For Question A, the Appointment table has been altered with a coulmn named "total_appointments_for_each_patient"
   it's defualt value is set 0, with the usage of subquery it gives details on the total appointments for the respective patient.
   which can be checked with the below query 
   
   select * from patient;

b) For Question B, overcoming many to many relationship a bridge table named patient_emergency_contact has been created which 
   consists patient_id from the patient table and ec_id from the emergency_table which helps in storing mutiple contacts for the
   patient if they wish. After creation the table is migrated with data from the other table using insert with subquery statements
   This Can be verified by running the below given query after running the test data 
   
   INSERT INTO patient_emergency_contact (
    patient_no,
    ec_id) 
    VALUES (
    72,
    4);
   COMMIT;
   
   
   SELECT
    p.patient_no,
    p.patient_fname
    || ' '
    || p.patient_lname AS patient_full_name,
    e.ec_fname
    || ' '
    || e.ec_lname      AS patient_emergency_contact_name,
    ltrim(e.ec_id)     AS patient_emergency_conatct_id
FROM
         patient p
    JOIN patient_emergency_contact ep
    ON p.patient_no = ep.patient_no
    JOIN emergency_contact         e
    ON e.ec_id = ep.ec_id;


c) For Question C, a new table named nurse_training_log has been created to record the taining activities between trainer_nurse 
   and trainee_nurse with unique training_id. The table draws a relationship with the table nurse by getting referencing it's 
   primary keys as foregin keys. Also check constraints has been placed to make sure the start_datetime is always lesser than the 
   end_datetime to maintain uniform data.
*/



--4(a)


ALTER TABLE patient ADD total_appointments NUMBER(5) DEFAULT 0;

UPDATE patient p
SET
    total_appointments = ltrim((
        SELECT
            COUNT(appt_no)
        FROM
            appointment a
        WHERE
            a.patient_no = p.patient_no
    ));

COMMIT;

desc patient;

SELECT
    *
FROM
    patient;
--4(b)

--Table Drop Statement starts

DROP TABLE patient_emergency_contact CASCADE CONSTRAINTS;

--Table Drop Statement ends

--Table Creation with constraints Starts

CREATE TABLE patient_emergency_contact (
    patient_no NUMBER(4),
    ec_id      NUMBER(4),
    CONSTRAINT new_patient_fk FOREIGN KEY ( patient_no )
        REFERENCES patient ( patient_no ),
    CONSTRAINT new_ec_id_fk FOREIGN KEY ( ec_id )
        REFERENCES emergency_contact ( ec_id ),
    CONSTRAINT patient_emergency_pk PRIMARY KEY ( patient_no,
                                                  ec_id )
);

--Table Creation with constraints Ends

--Comments for table patient_emergency_contact starts

COMMENT ON COLUMN patient_emergency_contact.patient_no IS
    'patient identifier(unique)';

COMMENT ON COLUMN patient_emergency_contact.ec_id IS
    'emergency_contact identifier(unique)';
    
--Comments for table patient_emergency_contact ends

-- Migrating primarykeys from patient table and emergency_contact table

INSERT INTO patient_emergency_contact (
    patient_no,
    ec_id
)
    SELECT
        patient_no,
        ec_id
    FROM
        patient
    WHERE
        ec_id IS NOT NULL;

COMMIT;
-- Migration ends     


--Display statements starts

desc patient_emergency_contact;

SELECT
    *
FROM
    patient_emergency_contact;

--Display statements end


--4(c)

DROP TABLE nurse_training_log CASCADE CONSTRAINTS;

CREATE TABLE nurse_training_log (
    training_id      NUMBER(4) NOT NULL,
    trainer_nurse_no NUMBER(4) NOT NULL,
    trainee_nurse_no NUMBER(4) NOT NULL,
    start_datetime   DATE NOT NULL,
    end_datetime     DATE NOT NULL,
    t_description    VARCHAR2(100),
    CONSTRAINT nurse_training_pk PRIMARY KEY ( training_id ),
    CONSTRAINT fk_trainee_nurse_no FOREIGN KEY ( trainee_nurse_no )
        REFERENCES nurse ( nurse_no ),
    CONSTRAINT fk_trainer_nurse_no FOREIGN KEY ( trainer_nurse_no )
        REFERENCES nurse ( nurse_no ),
    CONSTRAINT nurse_no_check CHECK ( trainer_nurse_no != trainee_nurse_no ),
    CONSTRAINT date_check CHECK ( start_datetime < end_datetime )
);

COMMENT ON COLUMN nurse_training_log.training_id IS
    'Training identifier(unique)';

COMMENT ON COLUMN nurse_training_log.trainer_nurse_no IS
    'Trainers nurse identifier(unique)';

COMMENT ON COLUMN nurse_training_log.trainee_nurse_no IS
    'Trainee nurse identifier(unique)';

COMMENT ON COLUMN nurse_training_log.start_datetime IS
    'Traning Start Date time';

COMMENT ON COLUMN nurse_training_log.end_datetime IS
    'Traning end Date time';

COMMENT ON COLUMN nurse_training_log.t_description IS
    'Traning Description';

desc nurse_training_log;

-- Test Data
/*INSERT INTO patient_emergency_contact (
    patient_no,
    ec_id) 
    VALUES (
    72,
    4);
   COMMIT;
   
   
   SELECT
    p.patient_no,
    p.patient_fname
    || ' '
    || p.patient_lname AS patient_full_name,
    e.ec_fname
    || ' '
    || e.ec_lname      AS patient_emergency_contact_name,
    ltrim(e.ec_id)     AS patient_emergency_conatct_id
FROM
         patient p
    JOIN patient_emergency_contact ep
    ON p.patient_no = ep.patient_no
    JOIN emergency_contact         e
    ON e.ec_id = ep.ec_id;
    
select * from patient;
*/