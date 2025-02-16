--*****PLEASE ENTER YOUR DETAILS BELOW*****
--T3-mns-json.sql

--Student ID: 34194037
--Student Name: Sachin Shivaramaiah
--Unit Code: FIT9132
--Applied Class No: 02_OnCampus

/* Comments for your marker:




*/

/*3(a)*/
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT TO GENERATE 
-- THE COLLECTION OF JSON DOCUMENTS HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer
  
SELECT
    JSON_OBJECT(
        '_id' VALUE a.appt_no,
        'datetime' VALUE to_char(a.appt_datetime, 'dd/mm/yyyy HH24:MI'),
        'provider_code' VALUE p.provider_code,
        'provider_name' VALUE nvl(p.provider_title, '')
            || ' '
            || nvl(p.provider_fname, '')
            || ' '
            || nvl(p.provider_lname, ''),
        'item_totalcost' VALUE SUM(i.item_stdcost * asi.as_item_quantity),
        'no_of_items' VALUE COUNT(asi.item_id),
        'items' VALUE JSON_ARRAYAGG(
            JSON_OBJECT(
                'id' VALUE i.item_id,
                'desc' VALUE i.item_desc,
                'standardcost' VALUE i.item_stdcost,
                'quantity' VALUE asi.as_item_quantity
            )
        ORDER BY
            i.item_id)
    ) || ',' AS json_output
FROM
    mns.appointment a
JOIN mns.apptservice_item asi
    ON a.appt_no = asi.appt_no
JOIN mns.item i
    ON asi.item_id = i.item_id
JOIN mns.provider p
    ON a.provider_code = p.provider_code
WHERE
    asi.as_item_quantity > 0
GROUP BY
    a.appt_no,
    a.appt_datetime,
    p.provider_code,
    nvl(p.provider_title, ''),
    nvl(p.provider_fname, ''),
    nvl(p.provider_lname, '')
ORDER BY
    a.appt_no;