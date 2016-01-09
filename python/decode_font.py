#!/usr/bin/python3

# Author: Nathanaël Jourdane
# Email: nathanael@jourdane.net
# Date: december 30, 2015
# GPL v2: http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html#SEC1

# This script allows you to decode an array of numbers in hexadecimal notation
# and print it as a decimal array, to you use it on OpenSCAD (which doesn't
# support hexadecimal notation).
# example hex array: http://sunge.awardspace.com/glcd-sd/node4.html

FILE_NAME = 'font'

with open(FILE_NAME, 'r') as f_in:
    lines = f_in.readlines()
    for line in lines:
        digit = [int(i, 16) for i in line.split(',')[:5]]

        print('[%3i, %3i, %3i, %3i, %3i], // %s' % (digit[0],digit[1],digit[2],digit[3],digit[4], line.split('//')[1].strip()))
