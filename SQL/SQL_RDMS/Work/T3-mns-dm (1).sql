--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T3-mns-dm.sql

--Student ID:34194037
--Student Name:Sachin Shivaramaiah
--Unit Code:FIT9132
--Applied Class No:	02_OnCampus

/* Comments for your marker:
a) For question A, Sequence has been created with respective drop sequence commands 

b) For question B, Tables emegrency_contact, appointment and patient has been inserted with respective data
   requirements by using created sequences.
   
c) For question C, Follow up appointment has been created with by aslo inserting previous reference appointment,
   same can be verified by running a select query at the end of question c.
   
d) For question D, the follow up appointment has been updated for the respective appointment number.
   same can be verified by running a select query at the end of question d.
   
e) For question E, the follow up appointment has been deleted. same can be verified by running a select 
   query at the end of question e.

*/


--3(a)

DROP SEQUENCE emergency_contact_seq;

CREATE SEQUENCE emergency_contact_seq START WITH 100 INCREMENT BY 5;

DROP SEQUENCE patient_seq;

CREATE SEQUENCE patient_seq START WITH 100 INCREMENT BY 5;

DROP SEQUENCE appointment_seq;

CREATE SEQUENCE appointment_seq START WITH 100 INCREMENT BY 5;

--3(b)

INSERT INTO emergency_contact VALUES (
    emergency_contact_seq.NEXTVAL,
    'Jonanthan',
    'Robey',
    '0412523122'
);


INSERT INTO patient VALUES (
    patient_seq.NEXTVAL,
    'Laura',
    NULL,
    '32 Epsilon Rd',
    'Gold Coast',
    'QLD',
    '4217',
    TO_DATE('1-Jan-2008', 'dd-Mon-yyyy'),
    '0412523124',
    'lr08@gmail.com',
    emergency_contact_seq.CURRVAL
);

INSERT INTO patient VALUES (
    patient_seq.NEXTVAL,
    'Lachlan',
    NULL,
    '32 Epsilon Rd',
    'Gold Coast',
    'QLD',
    '4217',
    TO_DATE('1-Jan-2012', 'dd-Mon-yyyy'),
    '0412523421',
    'lacr08@gmail.com',
    emergency_contact_seq.CURRVAL
);



INSERT INTO appointment VALUES (
    appointment_seq.NEXTVAL,
    TO_DATE('04-Sep-2023 15:30', 'dd-Mon-yyyy HH24:MI'),
    (
        SELECT
            provider_roomno
        FROM
            provider
        WHERE
                upper(provider_title) = upper('Dr')
            AND upper(provider_fname) = upper('Bruce')
            AND upper(provider_lname) = upper('Striplin')
    ),
    'S',
    (
        SELECT
            patient_no
        FROM
            patient
        WHERE
                upper(patient_fname) = upper('Laura')
            AND ec_id = (
                SELECT
                    ec_id
                FROM
                    emergency_contact
                WHERE
                        ec_phone = '0412523122'
                    AND upper(ec_fname) = upper('Jonanthan')
                    AND upper(ec_lname) = upper('Robey')
            )
    ),
    (
        SELECT
            provider_code
        FROM
            provider
        WHERE
                upper(provider_title) = upper('Dr')
            AND upper(provider_fname) = upper('Bruce')
            AND upper(provider_lname) = upper('Striplin')
    ),
    6,
    NULL
);

INSERT INTO appointment VALUES (
    appointment_seq.NEXTVAL,
    TO_DATE('04-Sep-2023 16:00', 'dd-Mon-yyyy HH24:MI'),
    (
        SELECT
            provider_roomno
        FROM
            provider
        WHERE
                upper(provider_title) = upper('Dr')
            AND upper(provider_fname) = upper('Bruce')
            AND upper(provider_lname) = upper('Striplin')
    ),
    'S',
    (
        SELECT
            patient_no
        FROM
            patient
        WHERE
                upper(patient_fname) = upper('Lachlan')
            AND ec_id = (
                SELECT
                    ec_id
                FROM
                    emergency_contact
                WHERE
                        ec_phone = '0412523122'
                    AND upper(ec_fname) = upper('Jonanthan')
                    AND upper(ec_lname) = upper('Robey')
            )
    ),
    (
        SELECT
            provider_code
        FROM
            provider
        WHERE
                upper(provider_title) = upper('Dr')
            AND upper(provider_fname) = upper('Bruce')
            AND upper(provider_lname) = upper('Striplin')
    ),
    6,
    NULL
);

commit;

--3(c)
INSERT INTO appointment VALUES (
    appointment_seq.NEXTVAL,
    (
        SELECT
            appt_datetime + INTERVAL '10' DAY
        FROM
            appointment
        WHERE
            patient_no = (
                SELECT
                    patient_no
                FROM
                    patient
                WHERE
                        upper(patient_fname) = upper('Lachlan')
                    AND ec_id = (
                        SELECT
                            ec_id
                        FROM
                            emergency_contact
                        WHERE
                                ec_phone = '0412523122'
                            AND upper(ec_fname) = upper('Jonanthan')
                            AND upper(ec_lname) = upper('Robey')
                    )
            )
    ),
    (
        SELECT
            provider_roomno
        FROM
            provider
        WHERE
                upper(provider_title) = upper('Dr')
            AND upper(provider_fname) = upper('Bruce')
            AND upper(provider_lname) = upper('Striplin')
    ),
    'L',
    (
        SELECT
            patient_no
        FROM
            patient
        WHERE
                upper(patient_fname) = upper('Lachlan')
            AND ec_id = (
                SELECT
                    ec_id
                FROM
                    emergency_contact
                WHERE
                        ec_phone = '0412523122'
                    AND upper(ec_fname) = upper('Jonanthan')
                    AND upper(ec_lname) = upper('Robey')
            )
    ),
    (
        SELECT
            provider_code
        FROM
            provider
        WHERE
                upper(provider_title) = upper('Dr')
            AND upper(provider_fname) = upper('Bruce')
            AND upper(provider_lname) = upper('Striplin')
    ),
    14,
    (
        SELECT
            appt_no
        FROM
            appointment
        WHERE
                appt_datetime = TO_DATE('04-Sep-2023 16:00', 'dd-Mon-yyyy HH24:MI')
            AND provider_code = (
                SELECT
                    provider_code
                FROM
                    provider
                WHERE
                        upper(provider_title) = upper('Dr')
                    AND upper(provider_fname) = upper('Bruce')
                    AND upper(provider_lname) = upper('Striplin')
            )
    )
);

commit;

SELECT
    appt_no,
    to_char(appt_datetime, 'dd-Mon-yyyy HH24:MI') as Appoint_datetime,
    appt_roomno,
    appt_length,
    patient_no,
    provider_code,
    nurse_no,
    appt_prior_apptno
FROM
    appointment;

--3(d)
UPDATE appointment 
SET
    appt_datetime = TO_DATE('4-Sep-2023 16:00', 'dd-Mon-yyyy HH24:MI') + INTERVAL '14'
    DAY
WHERE
    appt_prior_apptno IS NOT NULL
    AND appt_datetime = TO_DATE('10-Sep-2023 16:00', 'dd-Mon-yyyy HH24:MI') + INTERVAL
    '4' DAY;
commit;

SELECT
    appt_no,
    to_char(appt_datetime, 'dd-Mon-yyyy HH24:MI')as Appoint_datetime,
    appt_roomno,
    appt_length,
    patient_no,
    provider_code,
    nurse_no,
    appt_prior_apptno
FROM
    appointment;

--3(e)
DELETE FROM appointment
WHERE
    appt_datetime BETWEEN TO_DATE('15-Sep-2023', 'dd-Mon-yyyy') AND TO_DATE('22-Sep-2023'
    , 'dd-Mon-yyyy')
    AND provider_code = (
        SELECT
            provider_code
        FROM
            provider
        WHERE
                upper(provider_title) = upper('Dr')
            AND upper(provider_fname) = upper('Bruce')
            AND upper(provider_lname) = upper('Striplin')
    );

commit;

--Display Statements
SELECT
    appt_no,
    to_char(appt_datetime, 'dd-Mon-yyyy HH24:MI')as Appoint_datetime,
    appt_roomno,
    appt_length,
    patient_no,
    provider_code,
    nurse_no,
    appt_prior_apptno
FROM
    appointment;

-- Display Statements
SELECT
    *
FROM
    emergency_contact;

SELECT
    *
FROM
    patient;

    