# modified version of the script written by the Bentley Historical Library to automatically create Digital Objects by
# re-using archival object metadata in ArchivesSpace. Original script available at
# https://github.com/djpillen/bentley_scripts/blob/master/update_archival_object.py
# this script recreates the first steps in using a csv to locate archival objects and retrieve their metadata,
# but adds additional project-dependant metadata before creating the Digital Object, and creates Digital Object
# Components to hang file information off of rather than attaching files directly to the Digital Object.
# METS exports for every created Digital Object are also saved off in a folder labeled "METS".

# USAGE: aspace_batch_dao.py tab_file.txt where tab_file.txt is the output of aspace_ead_to_tab.xsl

import requests
import json
import sys
import os


def main():
    # set up some variables
    # aspace access
    aspace_url = 'http://cassandra.bc.edu:8089'
    username = 'admin'
    password = 'lessPr0c,m0rePr0d!'
    # the following group are based on assumptions and may need to be changed project-to-project.
    format_note = "reformatted digital"
    file_type = "image/tiff, image/jpeg"
    # use the tab file created with aspace_ead_to_tab.xsl to gather variables and make the API calls
    # tab_file = 'output.txt'
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
        collection_dates = metadata[4].split("/")
        # aspace login info
        auth = requests.post(aspace_url + '/users/' + username + '/login?password=' + password).json()
        session = auth['session']
        headers = {'X-ArchivesSpace-Session': session}
        params = {'ref_id[]': id_ref}
        lookup = requests.get(aspace_url + '/repositories/2/find_by_id/archival_objects', headers=headers, params=params).json()
        archival_object_uri = lookup['archival_objects'][0]['ref']
        archival_object_json = requests.get(aspace_url + archival_object_uri, headers=headers).json()
        # check for necessary metadata & only proceed if it's all present.
        print(archival_object_json)
        try:
            obj_title = archival_object_json['title']
        except KeyError:
            try:
                obj_title = archival_object_json['dates'][0]['expression']
            except KeyError:
                print("Item " + id_ref + " has no title or date expression. Please check the metadata & try again")
                sys.exit()
        # check for expression type 'single' before looking for both start and end dates
        date_json = create_date_json(archival_object_json, id_ref, collection_dates)
        # use the archival object type to inform the digital object type & language code.
        try:
            types_list = get_lang_code(archival_object_json['instances'][0]['instance_type'], id_ref)
        except KeyError:
            print("Item " + id_ref + " has no instance type assigned. Please check the metadata & try again")
            sys.exit()
        # make the JSON
        dig_obj = {'jsonmodel_type':'digital_object','title':obj_title, 'digital_object_type':types_list[0], 'language':types_list[1],
               'digital_object_id':'http://hdl.handle.net.2345.2/' + id_ref, 'notes':[{'content':
                [use_note], 'type':'userestrict', 'jsonmodel_type':'note_digital_object'},{'content':[dimensions_note],
                'type':'dimensions', 'jsonmodel_type':'note_digital_object'}, {'content':[format_note], 'type':'note','jsonmodel_type':'note_digital_object'},
                {'content':[file_type], 'type':'note', 'jsonmodel_type':'note_digital_object'}], 'dates':date_json}
        # format the JSON
        dig_obj_data = json.dumps(dig_obj)
        # Post the digital object
        dig_obj_post = requests.post(aspace_url + '/repositories/2/digital_objects', headers=headers, data=dig_obj_data).json()
        print(dig_obj_post)
        # Grab the digital object uri and only proceed if the DO hasn't already been created
        try:
            dig_obj_uri = dig_obj_post['uri']
        except KeyError:
            print("DO for item " + id_ref + " already exists. Moving to next item in list.")
            continue
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
        # create the mets call URI by modifying the digital object uri
        id_start = dig_obj_uri.rfind('/')
        mets_uri = dig_obj_uri[0:id_start] + '/mets' + dig_obj_uri[id_start:len(dig_obj_uri)] + '.xml'
        # Save off the METS export for the completed and fully component-laden Digital Object
        mets_call = requests.get(aspace_url + mets_uri, headers=headers)
        mets_file = mets_call.text
        if not os.path.exists('METS'):
            os.makedirs('METS')
        with open('METS/'+ id_ref + '.xml', 'w') as outfile:
            outfile.write(mets_file)
        outfile.close()


# put date json creation in a separate function because different types need different handling.
def create_date_json(jsontext, itemid, collection_dates):
    if "single" in jsontext['dates'][0]['date_type']:
        try:
            start_date = jsontext['dates'][0]['begin']
        except KeyError:
            print(
                "Item " + itemid + " has a single-type date with no start value. Please check the metadata & try again")
            sys.exit()
        expression = start_date
        date_json = [{'begin':start_date, 'date_type':'single', 'expression':expression, 'label':'creation', 'jsonmodel_type':'date'}]
        return date_json
    elif "single" not in jsontext['dates'][0]['date_type']:
        date_type = jsontext['dates'][0]['date_type']
        try:
            start_date = jsontext['dates'][0]['begin']
        except KeyError:
            try:
                expression = jsontext['dates'][0]['expression']
            except KeyError:
                print(itemid + " has no start date or date expression. Please check the metadata and try again.")
                sys.exit()
            if "undated" in expression:
                start_date = collection_dates[0]
                end_date = collection_dates[1]
                date_json = [{'begin': start_date, 'end': end_date, 'date_type': date_type, 'expression': expression,
                              'label': 'creation', 'jsonmodel_type': 'date'}]
                return date_json
            else:
                print(itemid + " has no start date and date expression is not 'undated'. Please check the metadata "
                               "and try again")
                sys.exit()
        try:
            end_date = jsontext['dates'][0]['end']
        except KeyError:
            print("Item " + itemid + " has no end date. Please check the metadata & try again")
            sys.exit()
        if end_date in start_date:
            expression = start_date
        else:
            expression = start_date + "-" + end_date
        date_json = [{'begin':start_date, 'end':end_date, 'date_type':date_type, 'expression':expression, 'label':'creation', 'jsonmodel_type':'date'}]
        return date_json


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


# This function assumes that anything that has linguistic content is in English. May need modifying on some projects.
def get_lang_code(instance_type, item_id):
    print(instance_type)
    if instance_type == "audio":
        return ["sound recording", "eng"]
    elif instance_type == "books":
        return ["text", "eng"]
    elif instance_type == "computer_disks":
        return ["software, multimedia", "zxx"]
    elif instance_type == "graphic material":
        return["still image", "zxx"]
    elif instance_type == "graphic_materials":
        return["still image", "zxx"]
    elif instance_type == "graphic materials":
        return["still image", "zxx"]
    elif instance_type == "maps":
        return["cartographic", "zxx"]
    elif instance_type == "mixed_materials":
        return["mixed material", "zxx"]
    elif instance_type == "mixed materials":
        return["mixed material", "zxx"]
    elif instance_type == "moving images":
        return["moving image", "zxx"]
    elif instance_type == "moving_images":
        return["moving image", "zxx"]
    elif instance_type == "photographs":
        return["still image", "zxx"]
    elif instance_type == "realia":
        return["three dimensional object", "zxx"]
    elif instance_type == "text":
        return["text", "eng"]
    else:
        print(item_id + " has an improperly formatted instance type. Please check the metadata & try again.")
        sys.exit()


main()
