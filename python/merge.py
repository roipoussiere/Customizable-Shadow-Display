#!/usr/bin/python3

# Author: Nathanaël Jourdane
# Email: nathanael@jourdane.net
# Date: december 30, 2015
# GPL v2: http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html#SEC1

# This script prepare the .scad file to be uploaded on Thingiverse:
# - replace the parameters by the default parameters;
# - replace the <include> declarations by their contents (Customizer app doesn't
# supports multiple .scad files.);
# - remove lines containing '/*TODO' or '/*NOTE'.

from re import split

MAIN_FILE = 'main.scad'
ATTACHED_FILES = ['file2.txt', ...]
OUT_FILE = 'customizable_digital_sundial.scad'
PARAMETERS_FILE = 'default_parameters'

# To set all parameters as default.
parameters = {}
with open(PARAMETERS_FILE) as f:
    for line in f:
        p = split(' = ', line.strip())
        parameters[p[0]] = p[1]

with open(OUT_FILE, 'w') as out_f:
    with open(MAIN_FILE) as main_f:
        for line in main_f:
            if ' = ' in line:
                p = split(r'( = |; )', line.strip())
                if p[0] in parameters:
                    out_f.write(line.replace(p[2], parameters[p[0]]))
                    continue
            if line[:9] == 'include <':
                with open(line[9:-2]) as f:
                    for i, l in enumerate(f):
                        if i >= 9:
                            out_f.write(l)
                continue
            if '/*TODO' in line or '/*NOTE' in line:
                continue
            out_f.write(line)
