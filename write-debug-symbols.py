import os
import sys

def write_debug_symbol_files(directory):
    print("process dsym for path {}".format(directory))
    for dirpath, dirnames, filenames in os.walk(directory):
        for file in filenames:
            if 'lib' in file or 'obs' in file or '.so' in file or '.dylib' in file:
                path = os.path.join(dirpath, file)
                print("processing file {}".format(path))
                os.system("dsymutil " + path)


if len(sys.argv) > 1:
    first_arg = sys.argv[1]
    print("Processing dir:", first_arg)
else:
    print("No argument provided.")

write_debug_symbol_files(first_arg)
os.system("dwarfdump --uuid  " + first_arg)
