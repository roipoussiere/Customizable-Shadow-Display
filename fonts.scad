/* *** CUSTOMISABLE DIGITAL SUNDIAL ***
Font file

Author: Nathanaël Jourdane
Email: nathanael@jourdane.net
Date: december 30, 2015
Licence: GPL v2 http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html#SEC1
Thingiverse: http://www.thingiverse.com/thing:1253190
GitHub: https://github.com/roipoussiere/Customizable-Digital-Sundial*/

/* You can edit the following arrays to customize your font, or create new
ones. Each font is stored in `chars_lists` and `char_fonts` on the same index.
`chars_lists` is the characters list of the fonts, while `char_fonts` is the
fonts itself.

**To modify a character:**
Edit an entry in `char_font`[font_index][char_index].

**To add a new character to a font:**
Add your character in `chars_lists`[font_index][any_char_index], then add its
font in `char_font`[font_index][same_char_index].

**To add a new font:**
Add an array of characters in `chars_lists`[any_index], then add the
corresponding array of your font in `chars_fonts`[same_font_index]

Each char in `chars_fonts` is an array of numbers representing the decimal
value of a column, where the most significant bit is the bottom of the digit.

The 5x7 font comes from: http://sunge.awardspace.com/glcd-sd/node4.html. */

/* Characters lists */

chars_lists =
// ASCII font (5x7)
[" !\"#%$&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~¤",
// Numbers font (4x6)
"0123456789:"];

/* Characters fonts */

chars_fonts = [[
// ASCII font 5x7
[  0,   0,   0,   0,   0], // (space)
[  0,   0,  95,   0,   0], // !
[  0,   7,   0,   7,   0], // "
[ 20, 127,  20, 127,  20], // #
[ 36,  42, 127,  42,  18], // $
[ 35,  19,   8, 100,  98], // %
[ 54,  73,  85,  34,  80], // &
[  0,   5,   3,   0,   0], // '
[  0,  28,  34,  65,   0], // (
[  0,  65,  34,  28,   0], // )
[  8,  42,  28,  42,   8], // *
[  8,   8,  62,   8,   8], // +
[  0,  80,  48,   0,   0], // ,
[  8,   8,   8,   8,   8], // -
[  0,  96,  96,   0,   0], // .
[ 32,  16,   8,   4,   2], // /
[ 62,  81,  73,  69,  62], // 0
[  0,  66, 127,  64,   0], // 1
[ 66,  97,  81,  73,  70], // 2
[ 33,  65,  69,  75,  49], // 3
[ 24,  20,  18, 127,  16], // 4
[ 39,  69,  69,  69,  57], // 5
[ 60,  74,  73,  73,  48], // 6
[  1, 113,   9,   5,   3], // 7
[ 54,  73,  73,  73,  54], // 8
[  6,  73,  73,  41,  30], // 9
[  0,  54,  54,   0,   0], // :
[  0,  86,  54,   0,   0], // ;
[  0,   8,  20,  34,  65], // <
[ 20,  20,  20,  20,  20], // =
[ 65,  34,  20,   8,   0], // >
[  2,   1,  81,   9,   6], // ?
[ 50,  73, 121,  65,  62], // @
[126,  17,  17,  17, 126], // A
[127,  73,  73,  73,  54], // B
[ 62,  65,  65,  65,  34], // C
[127,  65,  65,  34,  28], // D
[127,  73,  73,  73,  65], // E
[127,   9,   9,   1,   1], // F
[ 62,  65,  65,  81,  50], // G
[127,   8,   8,   8, 127], // H
[  0,  65, 127,  65,   0], // I
[ 32,  64,  65,  63,   1], // J
[127,   8,  20,  34,  65], // K
[127,  64,  64,  64,  64], // L
[127,   2,   4,   2, 127], // M
[127,   4,   8,  16, 127], // N
[ 62,  65,  65,  65,  62], // O
[127,   9,   9,   9,   6], // P
[ 62,  65,  81,  33,  94], // Q
[127,   9,  25,  41,  70], // R
[ 70,  73,  73,  73,  49], // S
[  1,   1, 127,   1,   1], // T
[ 63,  64,  64,  64,  63], // U
[ 31,  32,  64,  32,  31], // V
[127,  32,  24,  32, 127], // W
[ 99,  20,   8,  20,  99], // X
[  3,   4, 120,   4,   3], // Y
[ 97,  81,  73,  69,  67], // Z
[  0,   0, 127,  65,  65], // [
[  2,   4,   8,  16,  32], // "\"
[ 65,  65, 127,   0,   0], // ]
[  4,   2,   1,   2,   4], // ^
[ 64,  64,  64,  64,  64], // _
[  0,   1,   2,   4,   0], // `
[ 32,  84,  84,  84, 120], // a
[127,  72,  68,  68,  56], // b
[ 56,  68,  68,  68,  32], // c
[ 56,  68,  68,  72, 127], // d
[ 56,  84,  84,  84,  24], // e
[  8, 126,   9,   1,   2], // f
[  8,  20,  84,  84,  60], // g
[127,   8,   4,   4, 120], // h
[  0,  68, 125,  64,   0], // i
[ 32,  64,  68,  61,   0], // j
[  0, 127,  16,  40,  68], // k
[  0,  65, 127,  64,   0], // l
[124,   4,  24,   4, 120], // m
[124,   8,   4,   4, 120], // n
[ 56,  68,  68,  68,  56], // o
[124,  20,  20,  20,   8], // p
[  8,  20,  20,  24, 124], // q
[124,   8,   4,   4,   8], // r
[ 72,  84,  84,  84,  32], // s
[  4,  63,  68,  64,  32], // t
[ 60,  64,  64,  32, 124], // u
[ 28,  32,  64,  32,  28], // v
[ 60,  64,  48,  64,  60], // w
[ 68,  40,  16,  40,  68], // x
[ 12,  80,  80,  80,  60], // y
[ 68, 100,  84,  76,  68], // z
[  0,   8,  54,  65,   0], // {
[  0,   0, 127,   0,   0], // |
[  0,  65,  54,   8,   0], // }
[  28, 62, 124,  62,  28], // ~ = heart
[127, 127, 127, 127, 127]  // ¤ = full dark

],[
// Numbers font 4x6
[30, 41, 37, 30], // 0
[34, 63, 32, 0 ], // 1
[50, 41, 41, 38], // 2
[18, 33, 37, 30], // 3
[15, 8,  8,  63], // 4
[39, 37, 37, 25], // 5
[30, 37, 37, 25], // 6
[33, 17, 9,  7 ], // 7
[26, 37, 37, 26], // 8
[38, 41, 41, 30], // 9
[0,  20, 0,  0 ]  // :

]];
