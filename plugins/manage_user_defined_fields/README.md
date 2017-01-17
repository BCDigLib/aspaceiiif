This plugin hides any user defined fields that are default or not used for the specific type of item being created/edited (like Resources won't see user defined fields that are set up for Accessions).

To install, just activate the plugin in your config/config.rb file by
including an entry such as:

     AppConfig[:plugins] = ['manage_user_defined_fields']

And add the user defined field labels that you are using (defined in the common/locales/en.yml or frontend/config/locales/en.yml) for resources and accessions in frontend/assets/manage_user_defined_fields.js (arrays defined as RESOURCE_UDFS and ACCESSION_UDFS accordingly).

NOTE:

If you're using a path prefix, be sure to include the prefix in the
layout_head.html.erb (line 5).

