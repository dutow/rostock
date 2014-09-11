include <configuration.scad>
use <polyholes.scad>

width = 76;
height = carriage_height;

offset = rod_separation / 2;
cutout = 13;
middle = 2*offset - width/2;

module parallel_joints(reinforced) {
  difference() {
    union() {
      intersection() {
        cube([width, 20, platform_thickness], center=true);
        rotate([0, 90, 0]) cylinder(r=5, h=width, center=true);
      }
      intersection() {
        translate([0, 18, platform_thickness/2]) rotate([45, 0, 0])
          cube([width, reinforced, reinforced], center=true);
        translate([0, 0, 20]) cube([width, 35, 40], center=true);
      }
      translate([0, 8, 0]) cube([width, 20, platform_thickness], center=true);
    }
    rotate([0, 90, 0]) poly_cylinder(r=1.5, h=80, center=true, $fn=12);

    for (x = [-offset, offset]) {
      translate([x, 5.5, 0])
        cylinder(r=cutout/2, h=100, center=true, $fn=24);
      translate([x, -4.5, 0])
        cube([cutout, 20, 100], center=true);
      translate([x, 0, 0]) rotate([0, 90, 0]) rotate([0, 0, 30])
        cylinder(r=3.3, h=17, center=true, $fn=6);
    }
    translate([0, 2, 0]) cylinder(r=middle, h=100, center=true);
    translate([0, -8, 0]) cube([2*middle, 20, 100], center=true);
  }
}

module lm8uu_mount(d, h) {
  union() {
    difference() {
      intersection() {
        cylinder(r=d/2+3.5, h=h, center=true);
        translate([0, -8, 0]) cube([d+4, 13, h+1], center=true);
      }
      poly_cylinder(r=d/2, h=h+1, center=true);
    }
  }
}

module belt_mount() {
  translate([idler_bearing[1]/2 - 2, 0, 0]) {
    union() {
      #difference() {
        translate([0, 2, 0]) cube([4, 13, height], center=true);
        for (z = [-3.5, 3.5])
          translate([0, 5, z])
            cube([5, 13, 3], center=true);
      }
      for (y = [1.5, 5, 8.5]) {
        translate([0, y, 0]) cube([4, 1.2, height], center=true);
      }
    }
  }
}

module carriage() {
  translate([0, 0, height/2]) 
  union() {
    for (x = [-smooth_rod_separation/2, smooth_rod_separation/2]) {
      translate([x, 0, 0]) lm8uu_mount(d=smooth_rod_bearing[1], h=smooth_rod_bearing[2]);
    }
    belt_mount();
    difference() {
      union() {
        translate([0, -5.6, 0])
          cube([smooth_rod_separation-10, 5, height], center=true);
        translate([0, -carriage_hinge_offset, -height/2+4])
          parallel_joints(smooth_rod_bearing[1]+1);
      }
      // Screw hole for adjustable top endstop.
      translate([15, -16, -height/2+4])
        cylinder(r=1.5, h=20, center=true, $fn=12);
      for (x = [-smooth_rod_separation/2, smooth_rod_separation/2]) {
        translate([x, 0, 0])
          cylinder(r=smooth_rod_bearing[1]/2+0.5, h=height+1, center=true);
        // Zip tie tunnels.
        for (z = [-height/2+4, height/2-4])
          translate([x, 0, z])
            cylinder(r=smooth_rod_bearing[1]/2+5.5, h=3, center=true);
      }
    }
  }
}

carriage();

// Uncomment the following lines to check endstop alignment.
// use <idler_end.scad>;
// translate([0, 0, -20]) rotate([180, 0, 0]) idler_end();
