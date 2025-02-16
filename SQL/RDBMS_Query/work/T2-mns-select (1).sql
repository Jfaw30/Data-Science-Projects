--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T2-mns-select.sql

--Student ID:   34194037
--Student Name: Sachin Shivaramaiah
--Unit Code: FIT9136
--Applied Class No: 02_OnCampus

/* Comments for your marker:




*/

/*2(a)*/
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
    item_id,
    item_desc,
    item_stdcost,
    item_stock
FROM
    mns.item
WHERE
        item_stock >= 50
    AND item_desc LIKE '%composite%'
ORDER BY
    item_stock DESC,
    item_id;

/*2(b)*/
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer
SELECT
    provider_code,
    CASE
        WHEN provider_title IS NOT NULL
             AND provider_fname IS NOT NULL
             AND provider_lname IS NOT NULL THEN
            provider_title
            || ' '
            || provider_fname
            || ' '
            || provider_lname
        WHEN provider_title IS NOT NULL
             AND provider_fname IS NULL
             AND provider_lname IS NOT NULL THEN
            provider_title
            || ' '
            || provider_lname
        WHEN provider_title IS NULL
             AND provider_fname IS NOT NULL
             AND provider_lname IS NOT NULL THEN
            provider_fname
            || ' '
            || provider_lname
        ELSE
            nvl(provider_title, '')
            || nvl(provider_fname, '')
            || nvl(provider_lname, '')
    END AS provider_name
FROM
         mns.provider p
    JOIN mns.specialisation sp
    ON p.spec_id = sp.spec_id
WHERE
    upper(spec_name) = upper('PAEDIATRIC DENTISTRY')
ORDER BY
    p.provider_lname ASC,
    p.provider_fname,
    p.provider_code;
    

/*2(c)*/
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
    *
FROM
    mns.service;

SELECT
    service_code,
    service_desc,
    to_char(service_stdfee, '$999,999.99') AS high_service_fee
FROM
    mns.service
WHERE
    service_stdfee > (
        SELECT
            AVG(service_stdfee)
        FROM
            mns.service
    )
ORDER BY
    service_stdfee DESC,
    service_code ASC;

SELECT
    AVG(service_stdfee)
FROM
    mns.service; 

/*2(d)*/
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
    appt_no,
    appt_datetime,
    patient_no,
    patient_fname
    || ' '
    || patient_lname AS patient_full_name,
    lpad(to_char(appt_total_cost, '$99999.99'),
         25,
         ' ')        AS appointment_total_cost
FROM
    (
        SELECT
            a.appt_no,
            a.appt_datetime,
            p.patient_no,
            p.patient_fname,
            p.patient_lname,
            SUM(nvl(s.service_stdfee, 0) + nvl(i.item_stdcost * asi.as_item_quantity,
            0)) AS appt_total_cost
        FROM
                 mns.appointment a
            JOIN mns.patient          p
            ON a.patient_no = p.patient_no
            LEFT JOIN mns.apptservice_item asi
            ON a.appt_no = asi.appt_no
            LEFT JOIN mns.service          s
            ON asi.service_code = s.service_code
            LEFT JOIN mns.item             i
            ON asi.item_id = i.item_id
        GROUP BY
            a.appt_no,
            a.appt_datetime,
            p.patient_no,
            p.patient_fname,
            p.patient_lname
    ) ts
WHERE
    ts.appt_total_cost = (
        SELECT
            MAX(sub.appt_total_cost)
        FROM
            (
                SELECT
                    a.appt_no,
                    SUM(nvl(s.service_stdfee, 0) + nvl(i.item_stdcost * asi.as_item_quantity
                    , 0)) AS appt_total_cost
                FROM
                    mns.appointment      a
                    LEFT JOIN mns.apptservice_item asi
                    ON a.appt_no = asi.appt_no
                    LEFT JOIN mns.service          s
                    ON asi.service_code = s.service_code
                    LEFT JOIN mns.item             i
                    ON asi.item_id = i.item_id
                GROUP BY
                    a.appt_no
            ) sub
    )
ORDER BY
    appt_no;


-- where join mns.apptservcie aps  ;

/*2(e)*/
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
    s.service_code,
    s.service_desc   AS "Service_Description",
    s.service_stdfee AS "Service_Standard_Fee",
    a.apptserv_fee   AS "Appointment_Service_Fee",
    round(AVG(a.apptserv_fee) - s.service_stdfee,
          2)         AS "Service_Fee_Differential"
FROM
         mns.service s
    JOIN mns.appt_serv a
    ON s.service_code = a.service_code
GROUP BY
    s.service_code,
    s.service_desc,
    s.service_stdfee,
    a.apptserv_fee
ORDER BY
    s.service_code;



/*2(f)*/
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
    p.patient_no,
    p.patient_fname
    || ' '
    || p.patient_lname                                 AS patientname,
    floor(months_between(sysdate, p.patient_dob) / 12) AS currentage,
    COUNT(a.appt_no)                                   AS numappts,
    lpad(to_char(round((COUNT(
        CASE
            WHEN a.appt_prior_apptno > 0 THEN
                1
        END
    ) / COUNT(a.appt_no)) * 100,
                       1),
                 '990.0'),
         8)
    || '%'                                             AS followups
FROM
         mns.patient p
    JOIN mns.appointment a
    ON p.patient_no = a.patient_no
GROUP BY
    p.patient_no,
    p.patient_fname,
    p.patient_lname,
    p.patient_dob;


/*2(g)*/
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer


SELECT
    p.provider_code AS pcode,
    lpad(
        CASE
            WHEN COUNT(a.appt_no) = 0 THEN
                '-'
            ELSE
                to_char(COUNT(a.appt_no))
        END,
        10)        AS numberappts,
    lpad(
        CASE
            WHEN SUM(asi.apptserv_fee) IS NULL THEN
                '-'
            ELSE
                '$'
                || floor(SUM(asi.apptserv_fee))
                || '.'
                || lpad(mod(round(SUM(asi.apptserv_fee) * 100),
                            100),
                        2,
                        '0')
        END,
        10)        AS totalfees,
    lpad(
        CASE
            WHEN SUM(att.as_item_quantity) IS NULL THEN
                '-'
            ELSE
                to_char(SUM(att.as_item_quantity))
        END,
        7)         AS noitems
FROM
    mns.provider         p
    LEFT JOIN mns.appointment      a
    ON p.provider_code = a.provider_code
       AND a.appt_datetime BETWEEN TO_DATE('10-SEP-2023 09:00:00', 'DD-MON-YYYY HH24:MI:SS'
       ) AND TO_DATE('14-SEP-2023 17:00:00', 'DD-MON-YYYY HH24:MI:SS')
    LEFT JOIN mns.appt_serv        asi
    ON asi.appt_no = a.appt_no
    LEFT JOIN mns.apptservice_item att
    ON asi.appt_no = att.appt_no
GROUP BY
    p.provider_code
ORDER BY
    p.provider_code;