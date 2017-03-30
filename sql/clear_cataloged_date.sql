# This script clears the cataloged date from all events with dates that defaulted to the
# accession date of the linked record during migration.
# To check which records are affected:
/*
SELECT e.id, r.event_id, a.accession_date, d.expression FROM date d
JOIN event e ON e.id = d.event_id
JOIN event_link_rlshp r ON e.id = r.event_id
JOIN accession a ON a.id = r.accession_id
WHERE d.expression = a.accession_date
AND e.event_type_id = '296';
*/

UPDATE date d
JOIN event e ON e.id = d.event_id
JOIN event_link_rlshp r ON e.id = r.event_id
JOIN accession a ON a.id = r.accession_id
SET d.expression = null # Change null to desired value; e.g., 1-1-1900
WHERE d.expression = a.accession_date
AND e.event_type_id = '296';
