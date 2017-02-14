# This statement ensures appropriate capitalization for the component_id field, addressing 
# issue 13 in the issue reporting spreadsheet. This statement must be run with 'sub-subseries' 
# and sub-sub-subseries

UPDATE archival_object SET other_level = 'Sub-subseries' WHERE other_level = 'sub-subseries';
