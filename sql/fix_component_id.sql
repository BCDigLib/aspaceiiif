/* This statement removes the level of description from the component ID fields
(e.g., Series I becomes I). To remove different levels, substitute the 'Series '
with the level of description in question. */

UPDATE archival_object SET component_id=REPLACE(component_id, 'Series ', '')
WHERE component_id LIKE 'Series%';
