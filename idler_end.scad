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
    translate([0, 0, - h/2]) linear_extrude(height=idler_height_offset * 2, convexity=2) difference() {
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

x = 20.9; // Micro switch center.
y = 18.5; // Micro switch center.
endstop_angle = 45;
module idler_end() {
  translate([0, 0, h/2]) 
  difference() {
    union() {
      mirror([0, 0, 1]) bracket(h,bracing=idler_end_bracing,rods=false);
      if (box_idler) idler_box();
      translate([0, 7.0, - h/2 + idler_height_offset]) rotate([90 - tilt, 0, 0]) bearing_mount();
      // Micro switch placeholder.
      % translate([x, y, -h/2+4]) rotate([0, 0, endstop_angle]) {
          cube([19.6, 6.7, 10.7], center=true);
          translate([-19.6/2+7, 0, -10.7/2-1]) cube([2, 4, 2], center=true);
      }
      difference() {
        // Endstop mount
        hull() {
            translate([26, 8, -h/2+5]) cube([19, 0.1, 10], center=true);
            translate([x, y, -h/2+5]) rotate([0, 0, endstop_angle]) translate([0, -3.3, 0]) cube([19.6, 0.1, 10], center=true);
        }
        //translate([22, 15.88, -h/2+5]) cube([17, 14, 10], center=true);
        // Endstop mount
        translate([x, y, -h/2+4]) rotate([0, 0, endstop_angle]) translate([0, 2, 0]) cube([30, 10.7, 20], center=true);
        // Bed mount hole
        translate([30, 12, -h/2+5]) cylinder(r=3, h=20, center=true);
      }
    }
    // Micro switch screw holes
    #translate([x, y, -h/2+6]) rotate([0, 0, endstop_angle]) {
      for (xoff = [-9.5/2, 9.5/2])
        translate([xoff, 0, 0]) rotate([90, 0, 0]) translate([0, 0, -3.5]) poly_cylinder(r=0.7, h=20, center=false);
    }
    // Idler axle hole
    translate([0, 8, - h/2 + idler_height_offset]) rotate([90 - tilt, 0, 0])
      poly_cylinder(r=idler_bearing[0]/2, h=50, center=true);
  }
}

module fixing_bracket() {
  translate([0, 0, fixing_end_height/2]) 
  mirror([0, 0, 1]) bracket(fixing_end_height,bracing=fixing_end_bracing, rods=true);
}

//translate([0, 0, idler_end_height]) rotate([180, 0, 0]) idler_end();
translate([0, 0, fixing_end_height]) rotate([180, 0, 0]) fixing_bracket();
