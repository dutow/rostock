include <configuration.scad>
use <bracket.scad>
use <polyholes.scad>

h = idler_end_height; // Total height.
tilt = 2; // Tilt bearings upward (the timing belt is pulling pretty hard).

module bearing_mount() {
  hull() {
    translate([0, 0, 2.3]) cylinder(r1=idler_bearing[1]/2+1, r2=idler_bearing[1]/2-2, h=1.1, center=true);
    translate([0, 0, -2.3]) cylinder(r1=idler_bearing[1]/2-2, r2=idler_bearing[1]/2+1, h=1.1, center=true);
  }
}

module idler_box() {
    thickness=4;
    padding=4;
    round_rad=3;
    box_y=idler_bearing[2]*2+2;
    translate([0, 0, -h/2]) linear_extrude(height=h, convexity=2) difference() {
        hull() {
            translate([0, 5]) square([idler_bearing[1]+2*(thickness+padding), 1], center=true);
            for (x=[-1, 1]) {
                translate([x*(idler_bearing[1]/2+padding+thickness-round_rad), 5-box_y-thickness+round_rad]) circle(r=round_rad);
            }
        }
        hull() {
            translate([0, 5]) square([idler_bearing[1]+2*padding, 1], center=true);
            for (x=[-1, 1]) {
                translate([x*(idler_bearing[1]/2+padding-round_rad), 5-box_y+round_rad]) circle(r=round_rad);
            }
        }
    }
}

x = 17.7; // Micro switch center.
y = 16; // Micro switch center.

module idler_end() {
  translate([0, 0, h/2]) 
  difference() {
    union() {
      mirror([0, 0, 1]) bracket(h,fins=idler_fins);
      if (box_idler) idler_box();
      translate([0, 7.0, 0]) rotate([90 - tilt, 0, 0]) bearing_mount();
      // Micro switch placeholder.
      % translate([x, y, -h/2+4]) rotate([0, 0, 15])
          cube([19.6, 6.34, 10.2], center=true);
      difference() {
        translate([20, 11.88, -h/2+5])
          cube([18, 8, 10], center=true);
        translate([x, y, -h/2+4]) rotate([0, 0, 15])
          cube([30, 6.34, 20], center=true);
        translate([30, 12, -h/2+5])
          cylinder(r=3, h=20, center=true);
      }
    }
    translate([x, y, -h/2+6]) rotate([0, 0, 15]) {
      translate([-9.5/2, 0, 0]) rotate([90, 0, 0])
	poly_cylinder(r=0.7, h=26, center=true);
      translate([9.5/2, 0, 0]) rotate([90, 0, 0])
	poly_cylinder(r=0.7, h=26, center=true);
    }
    translate([0, 8, 0]) rotate([90 - tilt, 0, 0])
      poly_cylinder(r=idler_bearing[0]/2, h=50, center=true);
    for (z = [-7, 7]) {
      translate([0, 0, z]) screws();
    }
  }
}

idler_end();
