include <configuration.scad>

$fa = 12;
$fs = 0.5;
use <polyholes.scad>

w = 60; // Smooth rod distance (center to center)

module screws() {
  for (x = [-smooth_rod_separation/2, smooth_rod_separation/2]) {
    translate([x, 0, 0]) {
      // Push-through M3 screw hole.
      translate([0, -smooth_rod_radius-3, 0]) rotate([0, 90, 0])
	poly_cylinder(r=1.5, h=20, center=true);
      // M3 nut holder.
      translate([-x/5, -smooth_rod_radius-3, 0])
	rotate([30, 0, 0]) rotate([0, 90, 0])
	cylinder(r=3.2, h=2.3, center=true, $fn=6);
    }
  }
}

module bracket(h) {
  translate([0, 0, -h/2]) linear_extrude(height=h, convexity=2) difference() {
    union() {
      translate([0, 3-smooth_rod_radius]) square([smooth_rod_separation+12, smooth_rod_radius + 18], center=true);
      // Sandwich mount.
      translate([-smooth_rod_separation/2, 10]) circle(r=6, center=true);
      translate([smooth_rod_separation/2, 10]) circle(r=6, center=true);
      // Smooth rod mounting slot extra.
      for (x = [-smooth_rod_separation/2, smooth_rod_separation/2]) {
	translate([x, 0]) {
	  circle(r=smooth_rod_radius+2, center=true);
	}
      }
    }
    // Sandwich mount.
    translate([-smooth_rod_separation/2, 12]) poly_circle(r=1.5, center=true);
    translate([smooth_rod_separation/2, 12]) poly_circle(r=1.5, center=true);
    // Smooth rod mounting slots.
    for (x = [-smooth_rod_separation/2, smooth_rod_separation/2]) {
      translate([x, 0]) {
	poly_circle(r=smooth_rod_radius, center=true);
	translate([0, -10, 0]) square([2, 20], center=true);
      }
    }
    // Belt path.
    difference() {
      union() {
	translate([0, -5]) square([smooth_rod_separation-20, 20], center=true);
	translate([0, -9]) square([smooth_rod_separation-12, 20], center=true);
	translate([-smooth_rod_separation/2+10, 1]) circle(r=4, center=true);
	translate([smooth_rod_separation/2-10, 1]) circle(r=4, center=true);
      }
      // Smooth rod mounting slot extra.
      for (x = [-smooth_rod_separation/2, smooth_rod_separation/2]) {
	translate([x, 0]) {
	  circle(r=smooth_rod_radius+2, center=true);
	}
      }
    }
  }
}

translate([0, 0, 10]) bracket(20);
