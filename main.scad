/* *** CUSTOMISABLE SHADOW DISPLAY ***

Author: Nathanaël Jourdane
Email: nathanael@jourdane.net
Date: december 30, 2015
Licence: GPL v2 http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html#SEC1
Thingiverse: http://www.thingiverse.com/thing:1253190
GitHub: https://github.com/roipoussiere/Customizable-Digital-Sundial*/

/*** Customizer parameters ***/


/* [Main] */

// preview[view:south west]

// For each positions, separated by ';'.
text = "The;quick;brown;fox;jumps;over;the;lazy;dog.";

// In minutes
digit_duration = 20; // [5:120]

// Used to display the digits.
font = 0; // [0:ASCII (5x7),1:Numbers (4x6)]

// Duration between each digits (in %).
transition = 45; // [0:100]

// Where are you ?
hemisphere = 0;  // [0:Northen hemisphere, 1:Southen hemisphere]

gnomon_shape = 0; // [0:Boat, 1:Half-cylinder]

// To hold the gnomon.
holder = 1; // [1:Yes,0:No]

// To hold pieces together with a rod.
rod = 0; // [0:No, 1:2mm, 2:3mm, 3:4mm, 4:5mm]

/* [Advanced] */

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

 
 // Optimization.
 optimization = 1; // [1:Yes,0:No]
 

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

// Build positive holes for each pixel. Need to be substracted from the gnomon.
module holes() {
  // position of the first pixel
   t(x = px_w/2 - sp_char + sp_col, y = pixel_pos_y) {
 
 // for each pixel, build a positive hole by extruding a square.
   for(i=[0:nb_col-1], j=[0:nb_rows-1], k=[0:nb_pos])
     if(pixels[k][hemisphere ? nb_col-1-i : i][j] == 1) {
       t(x = i * (px_w+sp_col) + sp_char*(ceil((i+1)/len(chars_fonts[font][0]))),
             y = (hemisphere ? nb_rows-1-j : j) * sp_row) {
         t(x=-sp_char) r(y=90)
           cylinder(d=px_h*slots_factor, h=px_w, $fn=10);
         r(x = (nb_pos-k-0.5) * digit_angle - (90-(180-total_angle)/2) ) {
 			t(z = holes_diam/4 - 0.5)
 			linear_extrude(height=holes_diam/2, scale=[1,surface_px_h], center=true)
 				square([px_w, px_h], center=true);
 //Optimization by Margu
 			if ((optimization==1) && (k<nb_pos) && (pixels[k+1][hemisphere ? nb_col-1-i : i][j] == 1)) {
 				r(x = (-0.5) * digit_angle )
 				t(z = holes_diam/4 - 0.5)
 				linear_extrude(height=holes_diam/2, scale=[1,surface_px_h], center=true)
 				  square([px_w, px_h], center=true);
 			}
 //End of Optimization by Margu
 		}
 	  }	
     }
   }
 }

module cleaned_holes() {
  if(remove_thin_parts == 0) {
    holes();
  } else {
    remove_thin_parts() {
      holes();
      cube([remove_box_size, remove_box_size, remove_box_size]);
    }
  }
}
// Build the holder
module holder() {
  difference() {
    t(x=-holder_len, y=gnomon_center_y, z=washer_diam/2) r(y=90)
      cylinder(d=washer_diam+2*diam_dist, h=holder_len, $fn=30);
    union() {
      t(x=-holder_len, z=-10)
        cube([holder_len, grid_width+4, 10]);

      t(x=-holder_dist, y=gnomon_center_y, z=-0.1) {
        t(x=-nut_thick, y=-nut_width/2)
          cube([nut_thick, nut_width, washer_diam/2]);
        t(x=-nut_thick, z=washer_diam/2) r(y=90)
          cylinder(d=(nut_width)*1.14, h=nut_thick, $fn=6);

        t(x=-nut_thick-washer_thick, y=-washer_diam/2)
          cube([washer_thick, washer_diam, washer_diam/2]);
        t(x=-nut_thick-washer_thick, z=washer_diam/2) r(y=90)
          cylinder(d=washer_diam, h=washer_thick, $fn=50);

        t(x=-nut_thick-washer_thick-washer_dist-1, z=washer_diam/2) r(y=90)
          cylinder(d=screw_diam, h=washer_dist+1, $fn=30);
      }
    }
  }

}

// Build the half of the gnomon.
module half_gnomon() {
t(y=-gnom_rad)
  intersection() {
    t(y=pixel_pos_y) r(y=90)
      cylinder(r=gnom_rad, h=gnom_len, $fn=100);
    union() {
      t(y=pixel_pos_y-2) r(x=(90-(180-total_angle)/2))
        cube([gnom_len, gnom_rad*2, gnom_rad*2]);
      if (rod !=0 ) t(y=-rod_diam*0.63) difference() {
        union() {
          cube([gnom_len, rod_diam+3, rod_diam+3]);
          t(z=(rod_diam+3)/2) r(y=90)
            cylinder(d=rod_diam+3, h=gnom_len, $fn=20);
        }
        t(z=(rod_diam+3)/2) r(y=90)
          cylinder(d=rod_diam, h=gnom_len, $fn=20);
      }
    }
  }
}

// Build the basic shape of the gnomon, without the holes.
module gnomon() {
  if(holder)
    holder();
  if(gnomon_shape == 0) { // boat shape
    t(y=gnom_rad) {
      half_gnomon();
      mirror([0,1,0]) half_gnomon();
    }
  t(y=pixel_pos_y-2)
    cube([gnom_len, grid_width+4, gnom_rad]);
  } else { // half-cylinder shape
    t(y=(-5))
    intersection() {
      cube([gnom_len, (gnom_rad+5)*2, gnom_rad+5]);
      r(90, 0, 90) t(gnom_rad+5, 0, 0)
        cylinder(r=gnom_rad+5, h=gnom_len, $fn=100);
    }
  }
}

difference() { gnomon(); cleaned_holes(); }
