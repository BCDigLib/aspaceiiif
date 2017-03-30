# This statement removes the 'http://' prefix from the location field of digital objects.

UPDATE external_document SET location = REPLACE(location,'http://','');
