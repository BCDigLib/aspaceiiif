# Walks a directory full of image files to create a list for the batch DAO process
# Can only create files for one directory at a time; path and output file name will need to be changed
# between every run. Each run/directory represents one DAO.
import os


def main():
    # project specific variables
    msid = "Set item MSID here"
    output_file = "Set output file name here formatted as component unique identifier  .txt"
    file_names = []
    for root, dirs, files in \
            os.walk(os.path.normpath("C://path/to/image/folder")):
        for file in files:
            if msid in file:
                file_names.append(file)
        file_names.sort()
        outfile = open(output_file, 'w')
    for file in file_names:
        # weeds out non-final versions of images.
        if "target" not in file:
            outfile.write(str(file) + '\n')
    outfile.close()

main()
