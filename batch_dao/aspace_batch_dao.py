# modified version of the script written by the Bentley Historical Library to automatically create Digital Objects by
# re-using archival object metadata in ArchivesSpace. Original script available at
# https://github.com/djpillen/bentley_scripts/blob/master/update_archival_object.py
# this script recreates the first steps in using a csv to locate archival objects and retrieve their metadata,
# but adds additional project-dependant metadata before creating the Digital Object, and creates Digital Object
# Components to hang file information off of rather than attaching files directly to the Digital Object.

# USAGE: aspace_batch_dao.py tab_file.txt where tab_file.txt is the output of aspace_ead_to_tab.xsl

import requests
import json
import sys
import os


def main():
    # set up some variables
    # aspace access
    aspace_url = 'http://cassandra.bc.edu:8089'
    # fill in credentials of admin user
    username = ''
    password = ''
    # the following group are based on assumptions and may need to be changed project-to-project.
    format_note = "reformatted digital"
    obj_type = "still_image"
    file_type = "image/tiff, image/jpeg"
    # use the tab file created with aspace_ead_to_tab.xsl to gather variables and make the API calls
    tab_file = sys.argv[1]
    tab_in = open(tab_file, 'r')
    ead_data = tab_in.read()
    ead_lines = ead_data.splitlines()
    for line in ead_lines:
        # data from the file
        metadata = line.split("\t")
        use_note = metadata[3]
        dimensions_note = "1 " + metadata[2]
        aspace_id = metadata[1]
        id_ref = aspace_id[7:len(aspace_id)]
        # aspace login info
        auth = requests.post(aspace_url + '/users/' + username + '/login?password=' + password).json()
        session = auth['session']
        # id_ref = "ref12_48x"
        headers = {'X-ArchivesSpace-Session': session}
        params = {'ref_id[]': id_ref}
        lookup = requests.get(aspace_url + '/repositories/2/find_by_id/archival_objects', headers=headers, params=params).json()
        archival_object_uri = lookup['archival_objects'][0]['ref']
        archival_object_json = requests.get(aspace_url + archival_object_uri, headers=headers).json()
        # check for necessary metadata & only proceed if it's all present.
        try:
            obj_title = archival_object_json['title']
        except KeyError:
            print("Item " + id_ref + " has no title. Please check the metadata & try again")
            sys.exit()
        try:
            start_date = archival_object_json['dates'][0]['begin']
        except KeyError:
            print("Item " + id_ref + " has no start date. Please check the metadata & try again")
            sys.exit()
        try:
            end_date = archival_object_json['dates'][0]['end']
        except KeyError:
            print("Item " + id_ref + " has no end date. Please check the metadata & try again")
            sys.exit()
        if end_date in start_date:
            expression = start_date
        else:
            expression = start_date + "-" + end_date
        # make the JSON
        dig_obj = {'jsonmodel_type':'digital_object','title':obj_title, 'digital_object_type':obj_type,
               'digital_object_id':'http://hdl.handle.net.2345.2/' + id_ref, 'notes':[{'content':
                [use_note], 'type':'userestrict', 'jsonmodel_type':'note_digital_object'},{'content':[dimensions_note],
                'type':'dimensions', 'jsonmodel_type':'note_digital_object'}, {'content':[format_note], 'type':'note','jsonmodel_type':'note_digital_object'},
                {'content':[file_type], 'type':'note', 'jsonmodel_type':'note_digital_object'}], 'dates':[{'begin':start_date,
                'end':end_date, 'date_type':'inclusive', 'expression':expression, 'label':'creation', 'jsonmodel_type':'date'}]}
        # format the JSON
        dig_obj_data = json.dumps(dig_obj)
        # Post the digital object
        dig_obj_post =requests.post(aspace_url + '/repositories/2/digital_objects', headers=headers, data=dig_obj_data).json()
        print(dig_obj_post)
        # Grab the digital object uri
        dig_obj_uri = dig_obj_post['uri']
        # Build a new instance to add to the archival object, linking to the digital object
        dig_obj_instance = {'instance_type': 'digital_object', 'digital_object': {'ref': dig_obj_uri}}
        # Append the new instance to the existing archival object record's instances
        archival_object_json['instances'].append(dig_obj_instance)
        archival_object_data = json.dumps(archival_object_json)
        # Repost the archival object
        archival_object_update = requests.post(aspace_url + archival_object_uri, headers=headers, data=archival_object_data).json()
        print(archival_object_update)
        # find and open the component file to get the data to create digital object components. assumes files in the same
        # directory that include the ref_id in the filename and contain a list of all image files associated with the object
        files_list = os.listdir('.')
        for components_file in files_list:
            if id_ref in components_file:
                infile = open(components_file, 'r')
                contents = infile.read()
                file_names = contents.splitlines()
                # dictionary to store extension information
                files_dictionary = dict()
                # list of file names to keep the objects in order for posting
                keeping_track = []
                for filename in file_names:
                    # store the components by number in a dictionary that has a list of file extensions as values
                    # get the base version of the filename without an extension
                    period_loc = filename.index('.')
                    base_name = filename[0:period_loc]
                    if base_name not in files_dictionary:
                        version = get_type_data(filename)
                        files_dictionary[base_name] = [version]
                        keeping_track.append(base_name)
                    elif base_name in files_dictionary:
                        version = get_type_data(filename)
                        files_dictionary[base_name].append(version)

                for name in keeping_track:
                    dig_obj = {'jsonmodel_type': 'digital_object_component', 'file_versions': files_dictionary[name],
                           'title': name, 'display_string': name, 'digital_object': {'ref': dig_obj_uri}}
                    dig_obj_data = json.dumps(dig_obj)
                    print(dig_obj_data)
                    # Post the digital object
                    dig_obj_post = requests.post(aspace_url + '/repositories/2/digital_object_components', headers=headers,
                                             data=dig_obj_data).json()
                    print(dig_obj_post)

def get_type_data(filename):
    # Create JSON by file type - if we add more types, add more elif statements with appropriate use statements
    if 'jpg' in filename:
        version = {'file_uri': filename, 'use_statement': 'reference image', 'jsonmodel_type': 'file_version'}
    elif 'tif' in filename:
        version = {'file_uri': filename, 'use_statement': 'archive image', 'jsonmodel_type': 'file_version'}
    else:
        print(filename)
        print("Improperly formatted file name: please add extension to filename or to script.")
        sys.exit()
    return version


main()
