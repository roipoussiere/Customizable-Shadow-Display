# *** CUSTOMISABLE DIGITAL SUNDIAL ***
#
# Author: Nathanaël Jourdane
# Email: nathanael@jourdane.net
# Date: december 30, 2015
# Licence: GPL v2 http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html#SEC1
# Thingiverse: http://www.thingiverse.com/thing:1253190
# GitHub: https://github.com/roipoussiere/Customizable-Digital-Sundial

# This file aims to compare 2 .scad files representing a sundial. It slice the
# 3D-models in a given position, then generates a picture showing the 2
# superposed slices.

import sys
from os.path import abspath, splitext
from subprocess import call, check_output
from time import gmtime, strftime
from re import split

if(len(sys.argv)) < 2:
	print('Usage:\n%s source.scad compared.scad' % sys.argv[0])
	sys.exit(0)

TEMP_DIR = '/tmp/'

# original_file = 'sundial_test.scad'
original_file     = abspath(sys.argv[1])
compared_file     = abspath(sys.argv[2])
tmp_original_file = abspath(TEMP_DIR + sys.argv[1])
tmp_compared_file = abspath(TEMP_DIR + sys.argv[2])

# TODO: options -no -nc: desactiver compilation pour original / compared
# TODO: retourner pièce

def create_proj_scad(file, tmp_file):
	with open(file, 'r+') as f:
		lines = f.readlines()
		last = lines[-1:]
		lines = lines[:-1]
		lines += ["projection(cut=true)\n"]
		lines += ["scale(10) rotate([-90, 0, 0])\n"]
		lines += last

	with open(tmp_file, 'w+') as f:
		for line in lines:
			f.write(line)

def to_svg(file):
	cmd = 'openscad %s -o %s' % (file, file + '.svg')
	call(cmd, shell=True)

def merge_svg(original_svg, compared_svg):
	with open(original_svg, 'r+') as f:
		original_lines = f.readlines()
		svg_lines = original_lines[:3]
		original_lines = original_lines[5:-1]

	txt_pos = str(-int(split('="', split('" ', svg_lines[2])[1])[1]))

	with open(compared_svg, 'r+') as f:
		compared_lines = f.readlines()
		compared_lines = compared_lines[5:-1]

	with open(compared_file, 'r+') as f:
		params_lines = f.readlines()[20:35]
		params = []
		for param in params_lines:
			line = split(' // ', param)
			if (len(line) == 2):
				params.append(line[0].strip()[:-1])

	svg_lines += ['<g stroke="black" fill-opacity="0.5" stroke-width="0.5">\n']
	svg_lines += ['<path fill="red" d="\n'] + original_lines + ['"/>\n']
	svg_lines += ['<path fill="blue" d="\n'] + compared_lines + ['"/>\n']
	svg_lines += ['<text stroke="none" font-size="10" y="' + txt_pos + '">\n']
	svg_lines += ['<tspan fill="blue" x="3" dy="1.2em">' + compared_file + '</tspan>\n']
	svg_lines += ['<tspan fill="red" x="3" dy="1.2em">' + original_file + '</tspan>\n']
	for param in params:
		svg_lines += ['<tspan x="3" dy="1.2em">' + param + '</tspan>\n']
	svg_lines += ['</text>\n']
	svg_lines += ['</g> </svg>']

	diff_name = 'diff_' + strftime("%d-%m_%H:%M:%S", gmtime()) + '.svg'

	with open(diff_name, 'w+') as f:
		for line in svg_lines:
			f.write(line)

create_proj_scad(original_file, tmp_original_file)
create_proj_scad(compared_file, tmp_compared_file)

if '-no' in sys.argv:
	to_svg(original_file)
if '-nc' in sys.argv:
	to_svg(compared_file)

merge_svg(TEMP_DIR + original_file + '.svg', TEMP_DIR + compared_file + '.svg')
