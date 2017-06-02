Boston College ArchivesSpace Batch DAO Process

Object: To automatically generate description in ArchivesSpace for digitized archival materials, and to re-use that description to ingest files into the Digital Libraries repository (currently DigiTool).

Steps:
1. When material is selected for digitization, it is identified in ArchivesSpace by the addition of a Component Unique Identifier at the level of digitization (usually but not always the File level). The format of the Compnent Unique Identifier is as follows: the collection identifier reformatted as LLYYYY_NNN_ followed by the unique database ID number of the object in question (which is present in the ASpace URL when you are viewing the object as "tree::archival_object_NNNN - we are only interested in the number at the end of the URL, and it may consist of any number of digits). As an example, a properly formatted Component Unique Identifier may look like this: MS2013_043_54063.

2. Once all objects selected for digitization within a given collection have been marked with CUIs, export the EAD for the entire collection with only the "include <dao> tags" option checked.

3. Transform the collection EAD into a tab-delimited file using aspace_ead_to_tab.xsl. Send a copy of this file to the scanner, so that the CUIs can be used to generate filenames in the scanning process.

4. When the scanning is complete, each object should be represented by a folder named with the CUI and containing image files titled with the CUI and an order number (_0001, _0002, etc.) appended. Run dir_list.py over each folder to create .txt files containing lists of the image file names for each object. Make sure that these files are in the same directory as aspace_batch_dao.py and the tab file output by aspace_ead_to_tab.xsl.

5. Run aspace_batch_dao.py from the command line with the following usage: "aspace_batch_dao.py tab_file.txt" where tab_file.txt is the output of aspace_ead_to_tab.xsl. This will call on the ArchivesSpace API to create a Digital Object and Digital Object Components for each object and the image files that represent it. If there are errors, the object metadata in ArchivesSpace or various aspects of the python script may need editing.

6. After running aspace_batch_dao.py, there will now be a subdirectory titled "METS" containing the exported METS files for each newly created Digital Objects. Transform these into DigiTool-compliant METS using ASMETS_to_diglibMETS-Template.xsl. The output METS/XML files can then be used to ingest the image files into DigiTool as described at https://bcwiki.bc.edu/display/UL/DigiTool+Ingest+Workflow.

