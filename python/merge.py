#!/usr/bin/python3

# Author: Nathanaël Jourdane
# Email: nathanael@jourdane.net
# Date: december 30, 2015
# GPL v2: http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html#SEC1

# This script prepare the .scad file to be uploaded on Thingiverse and GitHub.
# Create PUSHED_MAIN_FILE, by
# - replacing the parameters by the default parameters;
# - removing comments containing 'NOTE' or 'param=something'.
# In addition for Thingiverse, create OUT_FILE, by
# - replacing the <include> declarations by their contents (Customizer app
# doesn't supports multiple .scad files.)

from re import split
from os.path import abspath, isfile

SCAD_FOLDER = '.'
MAIN_FILE = abspath(SCAD_FOLDER + '/' + '_main.scad')
PUSHED_MAIN_FILE = abspath(SCAD_FOLDER + '/' + 'main.scad')
OUT_FILE = abspath(SCAD_FOLDER + '/' + 'customizable_shadow_display.scad')
PARAMETERS_FILE = abspath('./python/default_parameters')

for f in [PARAMETERS_FILE, OUT_FILE, MAIN_FILE, PUSHED_MAIN_FILE]:
    if not isfile(f):
        print('Error: %s doest\'n exist.' % f)

parameters = {}
with open(PARAMETERS_FILE) as f:
    for line in f:
        p = split(' = ', line.strip())
        parameters[p[0]] = p[1]

with open(MAIN_FILE) as main_f:
    with open(PUSHED_MAIN_FILE, 'w') as out_f:
        for line in main_f:
            if ' = ' in line:
                if line[:4] == 'text':
                    p = split(r'( = )', line.strip()[:-1]) + [';']
                else:
                    p = split(r'( = |; )', line.strip())
                if p[0] in parameters:
                    out_f.write(line.replace(p[2], parameters[p[0]], 1))
                    continue
            if line[:2] in ['/*','//']:
                if any(s in line for s in ['TODO', 'NOTE', '=']):
                    continue
            out_f.write(line)

with open(PUSHED_MAIN_FILE) as main_f:
    with open(OUT_FILE, 'w') as out_f:
        for line in main_f:
            if line[:9] == 'include <':
                with open(abspath(SCAD_FOLDER + '/' + line[9:-2])) as f:
                    for i, l in enumerate(f):
                        if i >= 9:
                            out_f.write(l)
            out_f.write(line)
