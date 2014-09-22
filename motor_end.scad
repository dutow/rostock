include <configuration.scad>
use <bracket.scad>

h = motor_end_height; // Total height.
m = 29; // Motor mounting screws distance (center to center)

module motor_end() {
  translate([0, 0, h/2]) 
  difference() {
      bracket(h,fins=true);
    // Motor shaft (RepRap logo)
    rotate([90, 0, 0]) cylinder(r=12, h=40, center=true);
    translate([0, 0, sin(45)*12]) rotate([0, 45, 0])
      cube([12, 40, 12], center=true);
    // Motor mounting screw slots
    for (x = [-1,1], z=[-1, 1])
      translate([x*m/2, 0, z*m/2]) rotate([0, -1*x*z*45, 0]) cube([9, 40, 3], center=true);
    for (z = [-14, 0, 14]) {
      translate([0, 0, z]) screws();
    }
  }
}

motor_end();
