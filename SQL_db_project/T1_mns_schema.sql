--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T1-mns-schema.sql

--Student ID: 34194037
--Student Name: Sachin Shivaramaiah
--Unit Code: FIT9132
--Applied Class No: 02_OnCampus

/* Comments for your marker:




*/

-- Task 1 Add Create table statements for the white TABLES below
-- Ensure all column comments, and constraints (other than FK's)
-- are included. FK constraints are to be added at the end of this script

-- TABLE: APPOINTMENT
CREATE TABLE appointment (
    appt_no           NUMBER(7) NOT NULL,
    appt_datetime     DATE NOT NULL,
    appt_roomno       NUMBER(2) NOT NULL,
    appt_length       CHAR(1) NOT NULL,
    patient_no        NUMBER(4) NOT NULL,
    provider_code     CHAR(6) NOT NULL,
    nurse_no          NUMBER(3) NOT NULL,
    appt_prior_apptno NUMBER(7),
    CONSTRAINT appt_no_pk PRIMARY KEY ( appt_no )
);

-- Alter table details for appointment starts
ALTER TABLE appointment
    ADD CONSTRAINT appointment_uq UNIQUE ( appt_datetime,
                                           appt_roomno,
                                           patient_no,
                                           provider_code,
                                           appt_prior_apptno );

ALTER TABLE appointment
    ADD CONSTRAINT appt_lenght_chk CHECK ( appt_length IN ( 'S', 'T', 'L' ) );
-- Alter table details for appointment ends

-- Comments for appointment starts
COMMENT ON COLUMN appointment.appt_no IS
    'Appointment identifier(unique)';

COMMENT ON COLUMN appointment.appt_datetime IS
    'Appointment date_time (unique)';

COMMENT ON COLUMN appointment.appt_roomno IS
    'Appointment room number (unique)';

COMMENT ON COLUMN appointment.appt_length IS
    'Lenght of the Appointment Short,Standard,long(S,T,L, Respectively)';

COMMENT ON COLUMN appointment.patient_no IS
    'Patient Identifier (unique)';

COMMENT ON COLUMN appointment.provider_code IS
    'Provider Identifier (unique)';

COMMENT ON COLUMN appointment.nurse_no IS
    'Nurse Identifier (unique)';

COMMENT ON COLUMN appointment.appt_prior_apptno IS
    'Follow Up Identifier (unique)';
-- Comments for appointment ends

-- TABLE: EMERGENCY_CONTACT
CREATE TABLE emergency_contact (
    ec_id    NUMBER(4) NOT NULL,
    ec_fname VARCHAR2(30),
    ec_lname VARCHAR2(30),
    ec_phone CHAR(10) NOT NULL,
    CONSTRAINT ec_id_pk PRIMARY KEY ( ec_id )
);

-- Alter table details for emergency contact starts

ALTER TABLE emergency_contact ADD CONSTRAINT ec_phone_uq UNIQUE ( ec_phone );

-- Alter table details for emergency contact ends

-- Comments for emergency_contact starts
COMMENT ON COLUMN emergency_contact.ec_id IS
    'emergency_contact identifier(unique)';

COMMENT ON COLUMN emergency_contact.ec_fname IS
    'emergency_contact first Name';

COMMENT ON COLUMN emergency_contact.ec_lname IS
    'emergency_contact last Name';

COMMENT ON COLUMN emergency_contact.ec_phone IS
    'emergency_contact mobile number(unique)';

-- Comments for emergency_contact ends

-- TABLE: PATIENT
CREATE TABLE patient (
    patient_no            NUMBER(4) NOT NULL,
    patient_fname         VARCHAR2(30),
    patient_lname         VARCHAR2(30),
    patient_street        VARCHAR2(50) NOT NULL,
    patient_city          VARCHAR2(20) NOT NULL,
    patient_state         VARCHAR2(3) NOT NULL,
    patient_postcode      CHAR(4) NOT NULL,
    patient_dob           DATE NOT NULL,
    patient_contactmobile CHAR(10) NOT NULL,
    patient_contactemail  VARCHAR2(25) NOT NULL,
    ec_id                 NUMBER(4) NOT NULL,
    CONSTRAINT patient_no_pk PRIMARY KEY ( patient_no )
);

-- Alter table details for patient starts

ALTER TABLE patient
    ADD CONSTRAINT patient_state_ck CHECK ( patient_state IN ( 'NT', 'QLD', 'NSW', 'ACT'
    , 'VIC',
                                                               'TAS', 'SA', 'WA' ) );

-- Alter table details for patient ends

-- Comments for patient starts
COMMENT ON COLUMN patient.patient_no IS
    'patient identifier(unique)';

COMMENT ON COLUMN patient.patient_fname IS
    'patientt first name';

COMMENT ON COLUMN patient.patient_lname IS
    'patient last name';

COMMENT ON COLUMN patient.patient_street IS
    'Patient street address';

COMMENT ON COLUMN patient.patient_city IS
    'Patient residing city';

COMMENT ON COLUMN patient.patient_state IS
    'patient residing state NT,QLD,NSW,ACT,VIC,TAS,SA or WA';

COMMENT ON COLUMN patient.patient_postcode IS
    'patient residing post code';

COMMENT ON COLUMN patient.patient_dob IS
    'patient date of birth';

COMMENT ON COLUMN patient.patient_contactmobile IS
    'patient mobile number';

COMMENT ON COLUMN patient.patient_contactemail IS
    'patient email address';

COMMENT ON COLUMN patient.ec_id IS
    'patient emergency contact identifier';
    
-- Comments for patient ends

-- Add all missing FK Constraints below here
ALTER TABLE appointment
    ADD CONSTRAINT provider_code_fk FOREIGN KEY ( provider_code )
        REFERENCES provider ( provider_code );

ALTER TABLE appointment
    ADD CONSTRAINT nurse_no_fk FOREIGN KEY ( nurse_no )
        REFERENCES nurse ( nurse_no );

ALTER TABLE appointment
    ADD CONSTRAINT patient_no_fk FOREIGN KEY ( patient_no )
        REFERENCES patient ( patient_no );

ALTER TABLE appointment
    ADD CONSTRAINT follow_up_fk FOREIGN KEY ( appt_prior_apptno )
        REFERENCES appointment ( appt_no );

ALTER TABLE patient
    ADD CONSTRAINT ec_id_fk FOREIGN KEY ( ec_id )
        REFERENCES emergency_contact ( ec_id );