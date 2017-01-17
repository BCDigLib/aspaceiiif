BC ArchivesSpace
--------------------

This is the codebase for Boston College Library's installation of 
[ArchivesSpace](http://archivesspace.org). We are in the process of 
migrating from Archivists' Toolkit and are not yet running this 
application in production.
 
* Current version: v1.5.2
* [Internal documentation](https://bcwiki.bc.edu/display/UL/ArchivesSpace)
* [Technical documentation](http://archivesspace.github.io/archivesspace/)
* [API](http://archivesspace.github.io/archivesspace/api)
* [Official repo](https://github.com/archivesspace/archivesspace)

### Plugins

This instance uses the following plugins:

* [manage_user_defined_fields (Ohio State University Libraries)](https://github.com/osulibraries/manage_user_defined_fields)
* [timewalk (New York Public Library)](https://github.com/alexduryee/timewalk)
* [multiple_identifiers (New York Public Library)](https://github.com/alexduryee/multiple_identifiers)

### Excluded Files

We've excluded the following files and folders from this repo for reasons of security 
and/or practicality:

* config/config.rb (replaced with config.rb.template, which includes 
default configuration)
* data/
* logs/
* UPGRADING.md

### Credits

ArchivesSpace 1.0 was developed by [Hudson Molonglo](http://www.hudsonmolonglo.com)
in partnership with the New York University Libraries, UC San Diego
Libraries, and University of Illinois Urbana-Champaign Library and with
funding from the Andrew W. Mellon Foundation, organizational support from
LYRASIS, and contributions from diverse persons in the archives community.

This software is licensed under the Educational Community License, Version 2.0. 
See COPYING file for further licensing information.