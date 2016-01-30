/* *** CUSTOMISABLE SHADOW DISPLAY ***

Author: Nathanaël Jourdane
Email: nathanael@jourdane.net
Date: december 30, 2015
Licence: GPL v2 http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html#SEC1
Thingiverse: http://www.thingiverse.com/thing:1253190
GitHub: https://github.com/roipoussiere/Customizable-Digital-Sundial*/

/*** Customizer parameters ***/

/* [Main] */

black_segments();
debug();*/

// preview[view:south west]

// For each positions, separated by ';'.
text="0;1;2;3;4;5;6;7;8;9";

// In minutes
digit_duration = 20; // [5:120]

// Used to display the digits.
font = 0; // [0:ASCII (5x7),1:Numbers (4x6)]

// Duration between each digits (in %).
transition = 45; // [0:100]

// No transition between two successive pixels which remain lit.
optimisation = 1; // [1:Yes,0:No]

// Where are you ?
hemisphere = 0;  // [0:Northen hemisphere, 1:Southen hemisphere]

gnomon_shape = 0; // [0:Boat, 1:Half-cylinder]

// To hold the gnomon.
holder = 1; // [1:Yes,0:No]

// To hold pieces together with a rod.
rod = 0; // [0:No, 1:2mm, 2:3mm, 3:4mm, 4:5mm]

h_floor = 0.2;
/* [Advanced] */

// The minimum material deposit size.
dist = 2; // [0.2:5]
// Usually your slicer software do this. Take a very long time to process.
remove_thin_parts = 0; // [0:Nope, 1:0.05mm, 2:0.10mm, 3:0.15mm, 4:0.20mm, 5:0.30mm]
gnomon_radius = 25; // [5:50]
pixel_width = 6; // [2:20]
pixel_height = 1; // [0.5:5]
space_between_columns = 1; // [0.5:5]
space_between_rows = 7.5; // [0.5:10]
space_between_digits = 3; // [1:10]
// ...on the bottom of the gnomon.
enlarge_slots = 2; // [0: No, 1: XS (x1.25), 2:S (x1.5), 3: M(x2), 4: L (x2.5), 5: XL (x3)]
screw_size = 3; // [0:M3, 1:M4, 2:M5, 3:M6, 4:M8, 5:M10]

/*** Fonts ***/
include <fonts.scad>

/*** Generic functions for strings, vectors and numbers operations ***/
include <functions.scad>

/*** Useful shortcuts :-) ***/

module t(x=0,y=0,z=0) { translate([x,y,z]) children(); }
module r(x=0,y=0,z=0) { rotate([x,y,z]) children(); }

gnom_rad = gnomon_radius;
px_w     = pixel_width;
px_h     = pixel_height / 2; // because the holes rotation increase it
sp_col   = space_between_columns;
sp_row   = space_between_rows;
sp_char  = space_between_digits;

/*** Hidden variables on the Customizer-GUI ***/

holder_dist = 2; // distance between the nut hole and the digits
washer_dist = 2; // distance between the washer and the top of the gnomon
diam_dist   = 2; // difference between the washer and the holder diameter

/*** Computed variables ***/

/* Numbers */
nb_rows = get_nb_rows(); // number of rows
nb_digits = get_nb_digits(); // number of digits (maximum of each positions)
nb_col = nb_digits * len(chars_fonts[font][0]); // number of columns
nb_pos = len(split(text, ";")); // number of solar positions

digit_angle = digit_duration * 360/24/60; // angle between each position
total_angle = digit_angle * nb_pos ; // angle between the first to the last pos

/* Pieces dimentions */
gnom_len = nb_col*(px_w+sp_col) + (nb_digits-1)*sp_char + sp_col;
holes_diam = gnomon_shape == 1 ? // holes arcs diameter
  (gnom_rad+5)*2 / cos(total_angle/2) + 1 :  // half-cylinder shape
  gnom_rad*2 / sin((180-total_angle)/2) + 1; // boat shape
grid_width = sp_row * (nb_rows-1);
// pixel width on the surface of the cylinder
surface_px_h = (100-transition)/100*holes_diam*3.1415 * digit_angle/(360*px_h);
slots_factor = [1, 1.25, 1.5, 2, 2.5, 3][enlarge_slots];
rod_diam = [0, 2, 3, 4, 5][rod] + 0.3;
remove_box_size = [0, 0.05, 0.10, 0.15, 0.20, 0.30][remove_thin_parts];
/* Positions */
gnomon_center_y = (grid_width+4)/2 + px_h; // position of gnomon center
pixel_pos_y = gnom_rad - grid_width/2; // y pos of the first pixel
pixels = text2digits(text); // array of pixels representing the text

/* Holder */

// screw size:  M3   M4   M5   M6   M8   M10
screw_diam   = [3  , 4  , 5  , 6  , 8  , 10 ][screw_size] + 0.5;
nut_thick    = [2.4, 3.2, 4.7, 5.2, 6.8, 8.4][screw_size] + 1;
nut_width    = [5.5, 7  , 8  , 10 , 13 , 17 ][screw_size] + 0.5;
washer_diam  = [12 , 14 , 16 , 18 , 22 , 27 ][screw_size] + 1;
washer_thick = [0.8, 0.8, 1  , 1.2, 1.5, 2  ][screw_size] + 1;
holder_len = washer_dist + washer_thick + nut_thick + holder_dist;

/*** Modules to build the gnomon ***/

/*
Notations and data structures:
- `p` is a vector [`x`, `y`], which represents a point,
  where `x` is the horizontal position and `y` is the vertical position.
- `seg` is a vector [`p1`, `p2`], where `p1` and `p2` are the extremities points of the segment (see `p`).
- `d` is a vector [`a`, `b`], which represents a straight line
  (considered with infinite length, but `line()` displays it from y=[-100;+100])
  where y = `a`x + `b`.
- `zone` is a vector [`d1, d2`], a couple of lines representing a zone.
- `a` is a integer which represents an angle, in degrees.
- `sunray` zone is where the sun go through.
- `blackray` zone is where we need to block the sunrays by deposing material.
*/

// Writing these functions below turned my brain upside down during few nights.

// Returns the point with its rectangular coordinates are [angle, radius].
function polar2rect(a=0, r=1) =
  [r*cos(a) , r*sin(a)];

// Returns [angle, radius], the polar coordinates of `p`.
function rect2polar(p) =
  [atan(p[1]/p[0]), sqrt(pow(p[0], 2) + pow(p[1], 2))];

// Returns the distance of `seg`.
function distance(seg) =
  sqrt(pow(seg[1][0]-seg[0][0], 2) + pow(seg[1][1]-seg[0][1], 2));

// Returns the intersection point of `d1` and `d2`.
function get_inter(d1, d2) =
  [ (d2[1]-d1[1]) / (d1[0]-d2[0]) , (d1[0]*d2[1]-d1[1]*d2[0]) / (d1[0]-d2[0]) ];

// Returns the line `d` passing through `seg`.
function get_line(seg) =
  [ (seg[1][1]-seg[0][1])/(seg[1][0]-seg[0][0]) ,
  seg[0][1] - ((seg[1][1]-seg[0][1])/(seg[1][0]-seg[0][0]))*seg[0][0]];

function get_x(line, y=0) = (y-line[1])/line[0];

// Returns true if `d` intersects with `seg`, with a certain `tol`erence.
function is_inter(d, seg, tol=0.1, inter=false) =
  seg[0][0] > seg[1][0] ? is_inter(d, [seg[1], seg[0]], tol) :
  !inter ? is_inter(d, seg, tol, get_inter(get_line(seg), d)[0]) :
  inter - seg[0][0] > tol && seg[1][0] - inter > tol;

// Returns a vector of [p1, p2, is_light], corresponding to each position.
function get_rays(col, j=0, k=0, v=[], x_pos=false, a=false) =
  j == nb_rows-1 +1 ? v : // end: returns the vector
  k == nb_pos ? get_rays(col, j+1, 0, v) : // j loop
  !x_pos && !a ? get_rays(col, j, k, v, // init x_pos and a
    x_pos = (hemisphere==1 ? nb_rows-1-j : j) * sp_row + pixel_pos_y,
    a = (nb_pos-0.5-k) * digit_angle + (180-total_angle)/2) :
  get_rays(col, j, k+1, concat(v, [ [ tan(a) , -tan(a)*x_pos,
    pixels[k][hemisphere==1 ? nb_col-1-col : col][j] == 1 ? true : false ]]) );

// Rotate `d` with by the angle `a` from the point on the x-axis.
function rot_line(d, a) =
  [tan(atan(d[0])-a), d[1]*tan(atan(d[0])-a)/d[0]];

// Returns a vector of zones corresponding to the sunrays
function get_sunrays(rays, delta=false, i=0, v=[]) =
  // if end of loop, returns the vector
  i == len(rays) ? v :
  // if delta uninitialized, initialize it.
  !delta ? get_sunrays(rays, delta=(100-transition)/100 * digit_angle/2) :
  // if blackray: do nothing, if sunray: append to v
  get_sunrays(rays, delta, i+1,
    !rays[i][2] ? v :
    concat(v, [ [rot_line(rays[i], delta), rot_line(rays[i], -delta)] ]));

// Returns a vector of zones corresponding to the blakrays.
// These zones are merged if they are side by side.
function get_blackrays(rays, delta=false, left = false, i=0, v=[]) =
  // if end of loop, returns the vector.
  i == len(rays) ? v :
  // if delta uninitialized, initialize it.
  !delta ? get_blackrays(rays, delta=(1+transition/100) * digit_angle/2) :
  // else if blackray and (next is sunray or actual is last), append.
  !rays[i][2] && (rays[i+1][2] || i%nb_pos == nb_pos-1) ?
    get_blackrays(rays, delta, false, i+1, concat(v,[ [rot_line(rays[i], delta),
    rot_line(rays[left == false ? i : left], -delta)] ])) :
  // else if is blackray and next is blackray and left is empty, save left.
  !rays[i][2] && !rays[i+1][2] && left == false ?
    get_blackrays(rays, delta, i, i+1, v) :
  // else, do nothing.
  get_blackrays(rays, delta, left, i+1, v);

// Returns a vector of segments which makes a *floor* of blocks.
function get_floor(rays, delta=false, i=0, v=[]) =
  i==len(rays)-1 ? // end of loop
    concat(v, [[ [get_x(rot_line(rays[i], delta), h_floor), h_floor] ,
    [get_x(rot_line(rays[i], delta), 0)+sp_row, h_floor] ]]) :
  // init delta
  !delta ? get_floor(rays, delta=(100-transition)/100 * digit_angle/2) :
  i==0 ? // first pos
    get_floor(rays, delta, i+1,
    concat(v, [[ [get_x(rot_line(rays[i], -delta), 0)-sp_row, h_floor] ,
    [get_x(rot_line(rays[i], -delta), h_floor), h_floor] ]])) :
  i%nb_pos == 0 ? // if last pos of the pixel
    get_floor(rays, delta, i+1,
    concat(v, [[ [get_x(rot_line(rays[i-1], delta), h_floor), h_floor] ,
    [get_x(rot_line(rays[i], -delta), h_floor), h_floor] ]])) :
  get_floor(rays, delta, i+1, v);

// Returns a vector of segments where to deposit material to display the shadow.
function get_blocks(column, rays=false, blackrays=false, sunrays=false, h_seg=false, bad_sunray=0, i=0, v=[]) =
  // if end of loop, append floor and returns v
  i==len(blackrays) ? concat(v, get_floor(rays)) :
  !rays ? get_blocks(column, get_rays(column)) : // init rays
  // init blackrays and sunrays
  !blackrays ? get_blocks(column, rays, get_blackrays(rays), get_sunrays(rays)):
  // init h_seg each loop
  !h_seg ? get_blocks(column, rays, blackrays, sunrays,
    get_sunray_h_block(blackrays[i], dist), 0, i, v):
  // init bad_sunray each loop
  bad_sunray==0 ? get_blocks(column, rays, blackrays, sunrays, h_seg,
  is_inter_sunrays(h_seg, sunrays, 0.1), i, v):
  // then process black segment
  get_blocks(column, rays, blackrays, sunrays, false, 0, i+1, concat(v,
    [bad_sunray != false ?
    [get_inter(bad_sunray, blackrays[i][0]) ,
     get_inter(bad_sunray, blackrays[i][1])] : h_seg]));

// Returns a horizontal segment passing through the `zone` and measuring dist.
function get_sunray_h_block(zone, dist, y=false) =
  zone[0][0] == zone[1][0] ? false :
  !y ? get_sunray_h_block(zone, dist,
    y = (dist*zone[0][0]*zone[1][0] - zone[0][0]*zone[1][1] +
      zone[0][1]*zone[1][0]) / (zone[1][0] - zone[0][0]) ) :
  [ [(y-zone[1][1])/zone[1][0] , y] , [(y-zone[0][1])/zone[0][0] , y] ];

// Returs the line where `seg` intersects with the sunray `zone`, or false if
// `seg` doesn't intersect with any sunray.
function is_inter_sunrays(seg, sunrays, tol, i=0) =
  i == len(sunrays) ? false :
  is_inter(sunrays[i][0], seg, tol) ? sunrays[i][0] :
  is_inter(sunrays[i][1], seg, tol) ? sunrays[i][1] :
  is_inter_sunrays(seg, sunrays, tol, i+1);

// Translates `p`
function tr(p, x=0, y=0) = [p[0]+x, p[1]+y];

// *** Debuging modules ***

// Draw the point `p` on the RIGHT view.
module dot(p, type="cross", col="Black", size=1, lvl=0) {
  if(type=="square") {
    t(x=p[0], y=p[1], z=lvl) color(col) square([size, size], center=true);
  } else if (type == "lines") {
    segment([-99, p[1]], [99, p[1]], thkn=size);
    segment([p[0], -99], [p[0], 99], thkn=size);
  } else if (type == "cross") {
    segment([p[0]-size, p[1]], [p[0]+size, p[1]], col, size);
    segment([p[0], p[1]-size], [p[0], p[1]+size], col, size);
  }
}

// Draw the segment `seg` on the RIGHT view.
module segment(seg, col="Black", thkn = 1, lvl=0) {
  length = distance(seg);
  t(x=seg[0][0], y=seg[0][1], z=lvl)
  r(z=(seg[1][0]>=seg[0][0] ? -90 : 90)
    + atan( (seg[1][1]-seg[0][1]) / (seg[1][0]-seg[0][0]) ))
  t(y=length/2) color(col) square([thkn/5, length], center=true);
}

function line2seg(d) =
  d[0] == 0 ? [[0, d[1]] , [99, d[1]]] :
  [[(-d[1])/d[0], 0] , [(99-d[1])/d[0], 99]];

// Draw the line `d` on the RIGHT view.
module line(d, col="Black", thkn=1, lvl=0) {
  segment(line2seg(d), col, thkn, lvl);
}

// Draw the `zone` on the RIGHT view.
module draw_zone(zone, lvl=0) {
  line(zone[0], "Gray", lvl=lvl);
  line(zone[1], "Gray", lvl=lvl);
  t(z=lvl) polygon(points=
    [line2seg(zone[0])[0], line2seg(zone[0])[1],
    line2seg(zone[1])[1], line2seg(zone[1])[0]]);
}


/*changer get_blocks() en get_black_segs et créer get_black_polygons()*/
module black_segments() {
  for(i = [0:nb_col-1]) {
    t(z=i*5) linear_extrude(height=5) {
      for(seg=get_blocks(i)) { segment(seg); }
    }
  }
}

// Draw sunray zones, blackray zones and processed material segments, on the
// RIGHT view, in a OpenScad animation
module debug() {
  column = $t*nb_col;
  /*columns = 1;*/
  echo(str("Select animation view, then set FPS to *1* and Steps to *",
  $t*nb_col, "*."));
  rays = get_rays(column);
  sunrays = get_sunrays(rays);
  blackrays = get_blackrays(rays);

  for(ray=blackrays) { %draw_zone(ray, lvl=0); }
  for(ray=sunrays)   { #draw_zone(ray, lvl=1); }
  for(segment=get_blocks(column)) { segment(segment, "Blue", lvl=2); }
  t(y=-4) color("Black") text(str("col. ", $t*nb_col+1), size=3);
}
