# This statement removes the level of description from the component ID fields (e.g., Series I
# becomes I). To remove different levels, substitute the 'Series ' with the level of 
# description in question. This statement addresses issue 11 in the issue reporting spreadsheet.

UPDATE archival_object SET component_id=REPLACE(component_id, 'Series ', '') 
WHERE component_id LIKE 'Series%';

# For ID 9749, which is just Sub-Subseries without a number?