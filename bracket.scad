include <configuration.scad>

$fa = 12;
$fs = 0.5;
use <polyholes.scad>

round_rad=4;
min_pinch_thickness=4;


module screws() {
  screw_rad=3.0/2;
  nut_depth=2.3;
  for (x = [-1, 1]) {
    translate([x*smooth_rod_separation/2, 0, 0]) {
      // Push-through M3 screw hole.
      translate([0, -smooth_rod_radius-2*screw_rad, 0]) rotate([0, 90, 0])
	poly_cylinder(r=screw_rad, h=bracket_side_thickness+2, center=true);
      // M3 nut holder.
      translate([-x*(bracket_side_thickness/2-nut_depth/2+0.1), -smooth_rod_radius-2*screw_rad, 0])
	rotate([30, 0, 0]) rotate([0, 90, 0])
	cylinder(r=3.2, h=nut_depth, center=true, $fn=6);
    }
  }
}

module side_brackets(h, rods=false) {
    screw_inset = 12;
    rod_box_w = 20;
    rod_box_d = 15;
    rod_box_z = 30;
    rod_box_offset = bracket_bracket_length - rod_box_d;
    for (x = [0, 1]) mirror([x, 0, 0]) {
        // Diagonal fins.
        translate([(smooth_rod_separation + bracket_side_thickness-5)/2, 8, 0]) 
        rotate([0, 0, -30]) translate([-2.5, 0, -h/2]) {
            // Walls, with screw holes subtracted
            difference() {
                union() {
                    // Side wall
                    cube([5, bracket_bracket_length, h], center=false);
                    // Mounting block for length setting rods
                    if (rods) translate([-rod_box_w, rod_box_offset, 0]) cube([rod_box_w, rod_box_d, rod_box_z], center=false);
                }
                // Hole through mounting block
                if (rods) translate([-rod_box_w, rod_box_offset, 0]) translate([rod_box_w/2, -1, rod_box_z - rod_box_w/2]) rotate([-90, 0, 0]) cylinder(r = 4.2, h = rod_box_d + 2);
                // Screw holes in the side walls
                for (y1 = [7+screw_inset], z1 = [screw_inset]) translate([2.5, y1, z1]) rotate([0, 90, 0]) poly_cylinder(r=2, h=50, center=true);
            }
        }
    }
    // Base
    hull() for (x = [-1, 1]) {
        translate([x*(smooth_rod_separation + bracket_side_thickness-5)/2, 8, 0]) 
        rotate([0, 0, -x*30]) translate([-2.5, 15, -h/2])
        cube([5, 15, 5], center=false);
    }
}

module fins(h) {
    for (x = [-1, 1]) {
        // Diagonal fins.
        hull() {
            translate([x*smooth_rod_separation/2, bracket_fin_length-4, 8/2-h/2]) cube([5, 1, 8], center=true);
            translate([x*smooth_rod_separation/2, 15, 0]) #cube([5, 1, h], center=true);
        }
        // Extra mounting screw holes.
        translate([x*smooth_rod_separation/2, bracket_fin_length, 4-h/2]) difference() {
            cylinder(r=5, h=8, center=true, $fn=24);
            translate([0, 1, 0]) cylinder(r=1.9, h=9, center=true, $fn=12);
        }
    }
}

module bracket(h, bracing="none", rods=false) {
    num_screws = round(h / bracket_screw_separation);
    total_screw_sep = bracket_screw_separation * (num_screws - 1);
    difference() {
        union() {
            translate([0, 0, -h/2]) linear_extrude(height=h, convexity=3) difference() {
                union() {
                    translate([0, 3 - smooth_rod_radius]) square([smooth_rod_separation+bracket_side_thickness, smooth_rod_radius + 18], center=true);
                    for (x = [-smooth_rod_separation/2, smooth_rod_separation/2]) {
                        // Sandwich mount.
                        translate([x, 10]) circle(r=bracket_side_thickness/2, center=true);
                        // Smooth rod mounting slot extra.
	                translate([x, 0]) circle(r=smooth_rod_radius+min_pinch_thickness, center=true);
                    }
                }
                for (x = [-smooth_rod_separation/2, smooth_rod_separation/2]) {
                    // Sandwich mount.
                    translate([x, 12]) poly_circle(r=1.5, center=true);
                    // Smooth rod mounting slots.
                    translate([x, 0]) {
	                poly_circle(r=smooth_rod_radius, center=true);
	                translate([0, -10, 0]) square([2, 20], center=true);
                    }
                }
                // Belt path.
                difference() {
                    union() {
	                translate([0, -5]) square([smooth_rod_separation-bracket_side_thickness-2*round_rad, 20], center=true);
	                translate([0, -9]) square([smooth_rod_separation-bracket_side_thickness, 20], center=true);
                        for (x = [-1, 1]) {
	                    translate([x*(smooth_rod_separation/2-bracket_side_thickness/2-round_rad), 5-round_rad]) circle(r=round_rad, center=true);
                        }
                    }
                    // Smooth rod mounting slot extra.
                    for (x = [-smooth_rod_separation/2, smooth_rod_separation/2]) {
	                translate([x, 0]) {
	                    circle(r=smooth_rod_radius+min_pinch_thickness, center=true);
	                }
                    }
                }
            }
            if (bracing=="fins"||bracing=="both") fins(h);
            if (bracing=="brackets"||bracing=="both") side_brackets(h, rods=rods);
        }
        for (z = [-total_screw_sep/2 : bracket_screw_separation : total_screw_sep/2]) translate([0, 0, z]) screws();
    }
}

translate([0, 0, 10]) bracket(30, bracing="brackets");
