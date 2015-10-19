include <configuration.scad>
use <bracket.scad>

m = 47; // Motor mounting screws distance (center to center) 29 - nema17 47 - nema23

module motor_end() {
  translate([0, 0, motor_end_height/2]) 
  difference() {
      bracket(motor_end_height,bracing=motor_end_bracing, rods=false);
      translate([0, 0, motor_height_offset]) union() {
          // Motor shaft (RepRap logo)
          rotate([90, 0, 0]) cylinder(r=12, h=40, center=true);
          translate([0, 0, sin(45)*12]) rotate([0, 45, 0])
          cube([12, 40, 12], center=true);
          // Motor mounting screw slots
          for (x = [-1,1], z=[-1, 1])
          translate([x*m/2, 0, z*m/2]) rotate([0, -1*x*z*45, 0]) cube([9, 40, 3], center=true);
      }
  }
}

motor_end();
