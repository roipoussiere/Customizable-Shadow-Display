/* *** CUSTOMISABLE DIGITAL SUNDIAL ***
Functions file

Author: Nathanaël Jourdane
Email: nathanael@jourdane.net
Date: december 30, 2015
Licence: GPL v2 http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html#SEC1
Thingiverse: http://www.thingiverse.com/thing:1253190
GitHub: https://github.com/roipoussiere/Customizable-Digital-Sundial*/

// ** remove_thin_parts() { `object()`; `small_object()`; } **
// Remove thin parts of an `object`, with a *corrosive* `small_object()`.
module remove_thin_parts() {
  render(convexity = 1) {
    reverse() minkowski() {
      reverse() minkowski() { children(0); children(1); }
      children(1);
    }
  }
}

// ** reverse() { `object()`; } **
// Reverse an object. Solids becames holes, holes becames solids.
module reverse() {
  difference() {
    cube([1000, 1000, 1000], center=true);
    children();
  }
}

// ** [int] binary_size([int] `n`) **
// Returns the binary size of the number `n`, ie: 63 (0b111111) returns 6.
// - `n`: The number to converts.
function binary_size(n, s=0) =
  n == 1 ? s :
  binary_size(ceil(n/2), s+1);

// ** [vect] dec2bin([int] num, [[int] `len`]) **
// Returns a vector of booleans corresponding to the binary value of `num`.
// - `num`: The number to convert.
// - `len` (optional): The vector length. If specified, fill the MSBs with 0.
// dec2bin(42, 8); // [0, 0, 1, 0, 1, 0, 1, 0]
function dec2bin(num, length=8, v=[]) =
  len(v) == length ? v :
  num == 0 ? dec2bin(0, length, concat(0, v)) :
  dec2bin(floor(num/2), length, concat(num%2, v));

// ** [vect] split([str] `str`, [[char] `sep`]) **
// Returns a vector of substrings by cutting `str` each time where `sep` appears
// - `str`: The original string.
// - `sep`: The separator who cuts the string (" " by default).
// split("foo;bar;baz", ";"); // ["foo", "bar", "baz"]
function split(str, sep=" ", i=0, word="", v=[]) =
  i == len(str) ? concat(v, word) :
  str[i] == sep ? split(str, sep, i+1, "", concat(v, word)) :
  split(str, sep, i+1, str(word, str[i]), v);

// ** [vect] new_vector([int] `len`, [[any_type] `val`]) **
// Returns a vector with `len` elements initialised to the `val` value.
// - `len`: The length of the vector.
// - `val`: The values filled in the vector *(0 by default)*.
// new_vector(5); // [0, 0, 0, 0, 0]
function new_vector(n, val=0, v=[]) =
  n == 0 ? v :
  new_vector(n-1, val, concat(v, val));

/*** Functions to get the number of rows and columns ***/

// ** [int] get_nb_rows() **
// Returns the number of pixel rows of the display: it's the heighter letter
// used in the text (based on the chars_fonts[font]).
function get_nb_rows(i=0, nbrow=0) =
  i==len(chars_fonts[font]) ? binary_size(nbrow) :
  get_nb_rows(i+1, max(chars_fonts[font][i][1]) > nbrow ?
  max(chars_fonts[font][i][1]) : nbrow);

// ** [int] get_nb_cols() **
// Returns the number of pixel columns of the display: it's the maximum text
// width ( = summ of each digit width) for all positions.
function get_nb_digits(i=-1, nb_digits=0, v=[]) =
  i == -1 ? get_nb_digits(0, 0, split(text, ";")) :
  i == len(v)-1 ? nb_digits :
  get_nb_digits(i+1, len(v[i]) > nb_digits ? len(v[i]) : nb_digits, v);

/*** Functions to make the pixel array from the customized text ***/

// [vect] char2digit([str] `char`)
// Returns an array representing a digit who displays the specified `char`.
// - `char`: the character to convert.
// char2digit("1"); // [[0, 1, 1, 1, 1, 0], [1, 0, 0, 1, 0, 1],
// [1, 0, 1, 0, 0, 1], [0, 1, 1, 1, 1, 0]]
function char2digit(char, i=-1, digit=[]) =
  i == -1 ?
    (len(char) != 1 || search(chars_fonts[font], char) == undef) ? undef :
    char2digit(chars_fonts[font][search(char, chars_lists[font])[0]], 0):
  i == len(char) ? digit :
    char2digit(char, i+1, concat(digit, [dec2bin(char[i], nb_rows)]));

// [vect] word2digits([str] `word`)
// Returns an array of digits columns who displays the specified string `str`.
// - `word`: The string to converts.
// word2digits("123"); // vector digits made with char2digit()
function word2digits(word, v=[], i=0) =
  i == len(word) ? v :
  i == len(word)-1 ? word2digits(word, concat(v, char2digit(word[i])), i+1) :
  word2digits(word, concat(v, char2digit(word[i])), i+1);

// [vect] text2digits([str] `txt`)
// Returns an array of digits columns who displays the user specified `txt`
// - `txt`: a string with words for all positions, separated by a semicolon.
// text2digits("12;34"); // vector of vectors of digits made with word2digits()
function text2digits(txt, i=-1, v=[]) =
  i == -1 ? text2digits(split(txt, ";"), 0) :
  i == len(txt) ? v :
  text2digits(txt, i+1, concat(v, [word2digits(txt[i])]));
