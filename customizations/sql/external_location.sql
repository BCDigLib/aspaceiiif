# This statement removes the 'http://' prefix from the location field of digital objects, 
# addressing issue 8 in the issue tracker.

UPDATE external_document SET location = REPLACE(location,'http://','');