--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T2-mns-insert.sql

--Student ID:34194037
--Student Name:Sachin Shivaramaiah
--Unit Code:FIT9132
--Applied Class No:	02_OnCampus

/* Comments for your marker:




*/

--------------------------------------
--INSERT INTO emergency_contact
--select * from emergency_contact;
--------------------------------------


INSERT INTO emergency_contact VALUES (
    0001,
    'Matt',
    'Damon',
    '9874563214'
);

INSERT INTO emergency_contact VALUES (
    0002,
    'Mark',
    'Welberg',
    '5789641232'
);

INSERT INTO emergency_contact VALUES (
    0003,
    'Jhon',
    'Whick',
    '2587413690'
);

INSERT INTO emergency_contact VALUES (
    0004,
    'Tony',
    'Stark',
    '9874566542'
);

INSERT INTO emergency_contact VALUES (
    0005,
    'Puneeth',
    'Rajkumar',
    '2587413721'
);


--------------------------------------
--INSERT INTO patient
--select * from patient;
--------------------------------------


INSERT INTO patient VALUES (
    71,
    'Thanos',
    'Purple',
    'Stone street',
    'Melbourne City',
    'VIC',
    '3161',
    TO_DATE('1-Jan-1995', 'dd-Mon-yyyy'),
    '4568974132',
    'snap11@gmail.com',
    0004
);

INSERT INTO patient VALUES (
    72,
    'Shiva',
    'Rajkumar',
    'Bettina street',
    'Queens City',
    'QLD',
    '6161',
    TO_DATE('2-Feb-1972', 'dd-Mon-yyyy'),
    '1237898524',
    'jogi@gmail.com',
    0005
);

INSERT INTO patient VALUES (
    73,
    'Rajkumar',
    'Dodmane',
    'Arnott street',
    'Queens City',
    'QLD',
    '6162',
    TO_DATE('1-April-1954', 'dd-Mon-yyyy'),
    '3571594568',
    'doctor@gmail.com',
    0005
);

INSERT INTO patient VALUES (
    74,
    'Steve',
    'Rogers',
    'Glens street',
    'South warf City',
    'NSW',
    '7163',
    TO_DATE('2-Mar-1989', 'dd-Mon-yyyy'),
    '1579534567',
    'shield@gmail.com',
    0004
);

INSERT INTO patient VALUES (
    75,
    'Scarlett',
    'Jhon',
    'Oakliegh street',
    'Flinder City',
    'NT',
    '8163',
    TO_DATE('2-Jul-1994', 'dd-Mon-yyyy'),
    '1579534565',
    'widow@gmail.com',
    0001
);

INSERT INTO patient VALUES (
    76,
    'Tom',
    'Damon',
    'Peter street',
    'Bandura City',
    'ACT',
    '2167',
    TO_DATE('12-Aug-2006', 'dd-Mon-yyyy'),
    '1579534560',
    'TD@gmail.com',
    0001
);

INSERT INTO patient VALUES (
    77,
    'Jerry',
    'Whick',
    'OT street',
    'Bendigo City',
    'TAS',
    '8167',
    TO_DATE('2-Aug-2006', 'dd-Mon-yyyy'),
    '1579534560',
    'JW@gmail.com',
    0003
);

INSERT INTO patient VALUES (
    78,
    'Sara',
    'Whick',
    'PT street',
    'Silk City',
    'SA',
    '9164',
    TO_DATE('2-Aug-2008', 'dd-Mon-yyyy'),
    '3579534560',
    'SW@gmail.com',
    0003
);

INSERT INTO patient VALUES (
    79,
    'Ben',
    'Welberg',
    'Orong street',
    'Brown City',
    'WA',
    '2164',
    TO_DATE('2-Aug-2008', 'dd-Mon-yyyy'),
    '1579534566',
    'BW@gmail.com',
    0002
);

INSERT INTO patient VALUES (
    80,
    'Jessica',
    'Welberg',
    'Matt street',
    'Peter City',
    'NT',
    '3167',
    TO_DATE('2-Aug-2010', 'dd-Mon-yyyy'),
    '1579534556',
    'JW@gmail.com',
    0002
);



--------------------------------------
--INSERT INTO appointment
/* update appointment 
set appt_prior_apptno = 32
where appt_no = 52 ; */
--------------------------------------

INSERT INTO appointment VALUES (
    51,
    TO_DATE('16-Jul-2023 9:00', 'dd-Mon-yyyy HH24:MI'),
    2,
    'S',
    80,
    'GEN001',
    1,
    NULL
);

INSERT INTO appointment VALUES (
    52,
    TO_DATE('16-Jul-2023 10:00', 'dd-Mon-yyyy HH24:MI'),
    1,
    'L',
    79,
    'END001',
    2,
    NULL
);

INSERT INTO appointment VALUES (
    53,
    TO_DATE('16-Jul-2023 10:00', 'dd-Mon-yyyy HH24:MI'),
    3,
    'T',
    77,
    'GEN002',
    3,
    NULL
);

INSERT INTO appointment VALUES (
    54,
    TO_DATE('16-Jul-2023 11:00', 'dd-Mon-yyyy HH24:MI'),
    4,
    'S',
    76,
    'GEN003',
    4,
    NULL
);

INSERT INTO appointment VALUES (
    55,
    TO_DATE('16-Jul-2023 12:00', 'dd-Mon-yyyy HH24:MI'),
    5,
    'L',
    75,
    'ORS001',
    5,
    NULL
);

INSERT INTO appointment VALUES (
    32,
    TO_DATE('26-Jul-2023 9:00', 'dd-Mon-yyyy HH24:MI'),
    1,
    'T',
    79,
    'END001',
    15,
    52
);

INSERT INTO appointment VALUES (
    33,
    TO_DATE('26-Jul-2023 10:00', 'dd-Mon-yyyy HH24:MI'),
    3,
    'L',
    77,
    'GEN002',
    13,
    53
);

INSERT INTO appointment VALUES (
    34,
    TO_DATE('26-Jul-2023 11:00', 'dd-Mon-yyyy HH24:MI'),
    4,
    'S',
    76,
    'GEN003',
    9,
    54
);

INSERT INTO appointment VALUES (
    35,
    TO_DATE('26-Jul-2023 12:00', 'dd-Mon-yyyy HH24:MI'),
    5,
    'L',
    75,
    'ORS001',
    15,
    55
);

INSERT INTO appointment VALUES (
    60,
    TO_DATE('26-Jul-2023 15:00', 'dd-Mon-yyyy HH24:MI'),
    12,
    'T',
    78,
    'PER002',
    12,
    NULL
);

INSERT INTO appointment VALUES (
    56,
    TO_DATE('02-Aug-2023 9:00', 'dd-Mon-yyyy HH24:MI'),
    6,
    'S',
    74,
    'PED001',
    6,
    NULL
);

INSERT INTO appointment VALUES (
    57,
    TO_DATE('02-Aug-2023 10:00', 'dd-Mon-yyyy HH24:MI'),
    7,
    'T',
    73,
    'PED002',
    7,
    NULL
);

INSERT INTO appointment VALUES (
    58,
    TO_DATE('02-Aug-2023 11:00', 'dd-Mon-yyyy HH24:MI'),
    8,
    'S',
    72,
    'ORT001',
    8,
    NULL
);

INSERT INTO appointment VALUES (
    59,
    TO_DATE('02-Aug-2023 12:00', 'dd-Mon-yyyy HH24:MI'),
    11,
    'L',
    71,
    'PER001',
    11,
    NULL
);

INSERT INTO appointment VALUES (
    36,
    TO_DATE('02-Aug-2023 13:00', 'dd-Mon-yyyy HH24:MI'),
    12,
    'T',
    78,
    'PER002',
    1,
    60
);

commit;


--Display statements
select * from emergency_contact;

select * from patient;

SELECT
    appt_no,
    to_char(appt_datetime, 'dd-Mon-yyyy HH24:MI') as Appointment_date_time,
    appt_roomno,
    appt_length,
    patient_no,
    provider_code,
    nurse_no,
    appt_prior_apptno as Previous_appointment_number
FROM
    appointment; 


