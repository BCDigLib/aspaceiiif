# multiple_identifiers

A plugin to implement multiple identifiers (EAD `unitid`) in ArchivesSpace.

## Installation

- Download the plugin and copy it into your `archivesspace/plugins/multiple_identifiers/` directory
- Run `scripts/setup-database.sh` (Linux/OSX) or `scripts/setup-database.bat` (Windows)
- Add `'multiple_identifiers'` to the `AppConfig[:plugins]` line in `config/config.rb`
- Restart ArchivesSpace

## Features

- A new data element, *Identifier*, which is a repeatable field for Resources and Archival Objects.  Identifiers have a _Type_ (drop-down list) and _Value_ (String).
- Types can be edited via the Manage Controlled Terms list in ArchivesSpace
- Support for EAD export via the `<unitid type="your_selected_type">` XML element
- No MARC support (sorry!)